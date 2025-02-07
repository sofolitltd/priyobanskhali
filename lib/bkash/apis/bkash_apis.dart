import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/bkash/models/execute_payment_response.dart';
import '../models/create_payment_response.dart';
import '../models/grant_token_response.dart';
import '../utils/bkash_url.dart';
import 'bkash_credentials.dart';

class BkashApis {
  // Whether to use production or sandbox
  final bool production;

  BkashApis(this.production);

  String get baseUrl => production ? BkashUrl.production : BkashUrl.sandbox;

  // Grant token
  Future<GrantTokenResponse> grantToken() async {
    var url = "$baseUrl/tokenized/checkout/token/grant";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        // "Access-Control-Allow-Headers":
        //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        // "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Content-Type": "application/json",
        "Accept": "application/json",
        "username": production
            ? BkashCredentialsProduction.username
            : BkashCredentialsSandbox.username,
        "password": production
            ? BkashCredentialsProduction.password
            : BkashCredentialsSandbox.password,
      },
      body: Uint8List.fromList(
        utf8.encode(
          jsonEncode(
            {
              "app_key": production
                  ? BkashCredentialsProduction.appKey
                  : BkashCredentialsSandbox.appKey,
              "app_secret": production
                  ? BkashCredentialsProduction.appSecret
                  : BkashCredentialsSandbox.appSecret,
            },
          ),
        ),
      ),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return GrantTokenResponse.fromJson(response.body);
    } else {
      // Handle error
      print("Error granting token");
    }

    return GrantTokenResponse(
      statusCode: "statusCode",
      statusMessage: "statusMessage",
      idToken: "idToken",
      tokenType: "tokenType",
      expiresIn: 123,
      refreshToken: "refreshToken",
    );
  }

  // Create payment
  Future<CreatePaymentResponse> createPayment({
    required String idToken,
    required String amount,
    required String invoiceNumber,
    // required String courseID,
  }) async {
    var url = "$baseUrl/tokenized/checkout/create";
    //
    var payerReference = " ";
    if (!production) {
      payerReference = "01929918378";
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": idToken,
        "X-App-Key": production
            ? BkashCredentialsProduction.appKey
            : BkashCredentialsSandbox.appKey,
      },
      body: Uint8List.fromList(
        utf8.encode(
          jsonEncode(
            {
              "mode": "0011",
              "payerReference": payerReference,
              "callbackURL": 'https://sofolit.web.app/',
              "amount": amount,
              "currency": "BDT",
              "intent": "sale",
              "merchantInvoiceNumber": invoiceNumber,
            },
          ),
        ),
      ),
    );

    if (response.statusCode == 200) {
      print("create payment: ${response.body}");
      return CreatePaymentResponse.fromJson(response.body);
    } else {
      // Handle error
      print("Error creating payment");
    }

    return CreatePaymentResponse(
      paymentID: "paymentID",
      paymentCreateTime: "paymentCreateTime",
      transactionStatus: "transactionStatus",
      amount: "amount",
      currency: "currency",
      intent: "intent",
      merchantInvoiceNumber: "merchantInvoiceNumber",
      bkashURL: "bkashURL",
      callbackURL: "callbackURL",
      successCallbackURL: "successCallbackURL",
      failureCallbackURL: "failureCallbackURL",
      cancelledCallbackURL: "cancelledCallbackURL",
      statusCode: "statusCode",
      statusMessage: "statusMessage",
    );
  }

  // Execute payment
  Future<ExecutePaymentResponse> executePayment({
    required String idToken,
    required String paymentID,
  }) async {
    var url = "$baseUrl/tokenized/checkout/execute";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": idToken,
        "X-App-Key": production
            ? BkashCredentialsProduction.appKey
            : BkashCredentialsSandbox.appKey,
      },
      body: Uint8List.fromList(
        utf8.encode(
          jsonEncode(
            {
              'paymentID': paymentID,
            },
          ),
        ),
      ),
    );

    if (response.statusCode == 200) {
      print("Execute payment: ${response.body}");
      return ExecutePaymentResponse.fromJson(response.body);
    } else {
      // Handle error
      print("Error executing payment");
    }

    return ExecutePaymentResponse(
      paymentID: 'paymentID',
      customerMsisdn: 'customerMsisdn',
      payerReference: 'payerReference',
      paymentExecuteTime: 'paymentExecuteTime',
      trxID: 'trxID',
      transactionStatus: 'transactionStatus',
      amount: 'amount',
      currency: 'currency',
      intent: 'intent',
      merchantInvoiceNumber: 'merchantInvoiceNumber',
      statusCode: 'statusCode',
      statusMessage: 'statusMessage',
    );
  }
}
