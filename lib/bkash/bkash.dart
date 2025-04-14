import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:priyobanskhali/notification/fcm_sender.dart';

import '/bkash/apis/bkash_apis.dart';
import 'models/create_payment_response.dart';
import 'models/execute_payment_response.dart';
import 'models/grant_token_response.dart';
import 'views/bkash_payment_success.dart';
import 'views/bkash_web_view.dart';

class Bkash {
  /// Initiates and executes the bKash payment process
  static Future<void> payment({
    required bool production,
    required String amount,
    required String bookType,
    required String bookId,
    required String address,
  }) async {
    try {
      final grantTokenResponse = await _getGrantToken(production);
      final createPaymentResponse =
          await _createPayment(production, grantTokenResponse.idToken, amount);

      final paymentResult = await _openBkashWebView(createPaymentResponse);

      if (paymentResult == "success") {
        await _executePayment(
          production,
          grantTokenResponse.idToken,
          createPaymentResponse.paymentID,
          bookType,
          bookId,
          amount,
          address,
        );
      } else {
        Fluttertoast.showToast(msg: "Payment Failed or Cancelled");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment Error: $e');
      debugPrint('Payment Error: $e');
    }
  }

  /// Retrieves grant token from bKash API
  static Future<GrantTokenResponse> _getGrantToken(production) async {
    return await BkashApis(production).grantToken();
  }

  /// Creates a new bKash payment request
  static Future<CreatePaymentResponse> _createPayment(
      production, String idToken, String amount) async {
    return await BkashApis(production).createPayment(
      idToken: idToken,
      amount: amount,
      invoiceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Opens WebView for bKash payment
  static Future<String?> _openBkashWebView(
      CreatePaymentResponse payment) async {
    return await Get.to(
      () => BkashWebView(
        url: payment.bkashURL,
        successURL: payment.successCallbackURL,
        failureURL: payment.failureCallbackURL,
        cancelURL: payment.cancelledCallbackURL,
      ),
    );
  }

  /// Executes payment after success response
  static Future<void> _executePayment(
    production,
    String idToken,
    String paymentID,
    String bookType,
    String bookId,
    String bookPrice,
    String address,
  ) async {
    final executePaymentResponse = await BkashApis(production).executePayment(
      idToken: idToken,
      paymentID: paymentID,
    );

    if (executePaymentResponse.transactionStatus == "Completed") {
      await _storeOrderData(
          executePaymentResponse, bookType, bookId, bookPrice, address);

      if (bookType == 'book') {
        // send notification to admin
        FCMSender.sendNotification(
          title: 'New $bookType Order – Action Needed',
          body: 'A customer just placed a $bookType order. Review it now.',
          topic: 'orders',
        );
      }

      //
      _navigateToSuccessPage(executePaymentResponse.paymentID);
    } else {
      Fluttertoast.showToast(msg: "Payment Execution Failed!");
    }
  }

  /// Stores order data in Firebase (currently commented)
  static Future<void> _storeOrderData(
    ExecutePaymentResponse result,
    String bookType,
    String bookId,
    String bookPrice,
    String address,
  ) async {
    //

    // place order
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(result.paymentID)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'paymentId': result.paymentID,
      'paymentTime': result.paymentExecuteTime,
      'orderId': result.trxID,
      'price': bookPrice,
      'bookType': bookType,
      'bookId': bookId,
      'mobile': result.payerReference,
      'address': address,
      'date': DateTime.now(),
      'status': bookType == 'book' ? "Pending" : 'Complete',
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(bookType)
          .doc(bookId)
          .set({
        'bookId': bookId,
      }).then((value) {
        // toast
        // Fluttertoast.showToast(msg: 'Congratulations. Payment successful');
        print('Congratulations. Payment successful');
      });
    });
  }

  /// Navigates to the payment success page
  static void _navigateToSuccessPage(String orderNo) {
    Get.off(
      () => PaymentSuccessPage(orderNo: orderNo),
    );
  }
}
