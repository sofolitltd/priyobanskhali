import 'dart:convert';

import 'package:http/http.dart' as http;

class FCMSender {
//
  sendPushMessage({
    required String topic,
    required String title,
    required String body,
  }) async {
    try {
      //
      print("fcm");

      //
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAJ3jraTs:APA91bHWfyErZWnPrFaNKS3GU568MECGA987ZSkGwqWlTscJWwXJ9dEZC-tOWtdno4KOi50ewzHlmuRbfB7e-UTw8Lmb0_o-TU9CZQqww9Pjh10EnLBjgv34208ZJNf6zlvTizOSq3V4',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'type': 'notice',
              'status': 'done',
            },
            "to": '/topics/$topic',
          },
        ),
      );
    } catch (e) {
      print("Error push notification $e");
    }
  }
}
