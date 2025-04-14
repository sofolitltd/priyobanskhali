import 'dart:convert';
import 'dart:developer' as devtools;

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class FCMSender {
  //
  static Future<bool> sendNotification({
    // required String token,
    required String title,
    required String body,
    required String topic,
    String? image,
  }) async {
    // change this path according to project
    var filePath = 'assets/data/priyobanskhalibd.json';

    //
    final jsonCredentials = await rootBundle.loadString(filePath);
    final credentials =
        auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    //
    final client = await auth.clientViaServiceAccount(
      credentials,
      ['https://www.googleapis.com/auth/cloud-platform'],
    );

    //
    final notificationData = {
      'message': {
        'topic': topic,
        'notification': {
          'title': title,
          'body': body,
          if (image != null) 'image': image,
        },
        'data': {
          'type': topic,
          if (image != null) 'image': image,
        },
      },
    };

    //change as your project id
    const String senderId = 'priyobanskhalibd';

    //
    final response = await client.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      devtools.log('Notification Response code: ${response.statusCode}');

      return true; // Success!
    }

    devtools.log(
        'Notification Sending Error Response status: ${response.statusCode}');
    devtools.log('Notification Response body: ${response.body}');
    return false;
  }
}
