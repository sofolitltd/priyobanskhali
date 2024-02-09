import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'credentials.dart';

class BkashGateway {
  //
  static Future<void> paymentCheckout(context, double price, bookId) async {
    // when use [ Sandbox credentials ]
    //user: 01619777282 pin: 12121 otp: 123456
    //var credentials = const BkashCredentials(
    //   username: SandboxCredentials.username,
    //   password: SandboxCredentials.password,
    //   appKey: SandboxCredentials.appKey,
    //   appSecret: SandboxCredentials.appSecret,
    //   isSandbox: true,
    // );

    // // when use [ Live credentials ]
    var credentials = const BkashCredentials(
      username: LiveCredentials.username,
      password: LiveCredentials.password,
      appKey: LiveCredentials.appKey,
      appSecret: LiveCredentials.appSecret,
      isSandbox: false,
    );

    final flutterBkash = FlutterBkash(bkashCredentials: credentials);

    // tranId
    String generateInvoiceNumber() {
      // Create a random number generator.
      final Random random = Random();

      // Generate a random number in the range 10000 to 99999.
      final int randomNumber = random.nextInt(90000) + 10000;

      // Convert the random number to a string.
      final String random5DigitNumber = randomNumber.toString();

      // Return the random 5-digit number.
      return random5DigitNumber.toString();
    }

    /// Goto BkashPayment page & pass the params
    try {
      /// call pay method to pay without agreement as parameter pass the context, amount, merchantInvoiceNumber
      final result = await flutterBkash.pay(
        context: context,
        amount: 1,
        // need it double type
        // payerReference: "01619777283",
        payerReference: "00011122233",
        merchantInvoiceNumber: generateInvoiceNumber(),
      );

      /// if the payment is success then show the log
      // print(result.toString());
      Navigator.pop(context);

      // place order
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(result.paymentId)
          .set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'orderId': result.trxId,
        'price': price,
        'bookId': bookId,
        'mobileNo': result.payerReference,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('books')
            .doc(bookId)
            .set({
          'bookId': bookId,
        }).then((value) {
          // toast
          Fluttertoast.showToast(msg: 'Congratulations. Payment successfully');
        });
      });
    } on BkashFailure catch (e, st) {
      /// if something went wrong then show the log
      // print(e.message);
      // print(st);

      Navigator.pop(context);

      /// if something went wrong then show the snack-bar
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e, st) {
      /// if something went wrong then show the log
      // print(e);
      // print(st);
      Navigator.pop(context);

      /// if something went wrong then show the snack-bar
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }

    return;
  }
}
