import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
      ),

      // float
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          Get.to(() => const AddNotification());
        },
        child: const Icon(Icons.add),
      ),

      // body
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No notification found'));
            }

            return ListView.separated(
              itemCount: docs.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (_, index) {
                var data = docs[index];
                //
                return GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     data.get('image') == ''
                        //         ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                        //         : data.get('image'),
                        //   ),
                        // ),
                        title: Text(data.get('email')),
                        subtitle: Text('role: ${data.get('role')}'),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete admin'),
                                content: const Text(
                                    'Are you sure to delete this admin?'),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      const SizedBox(width: 16),

                                      //
                                      ElevatedButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('admin')
                                              .doc(data.id)
                                              .delete()
                                              .then(
                                            (value) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Delete admin successfully');

                                              //
                                              Get.back();
                                            },
                                          );
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

//
class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              //message
              TextFormField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('Message'),
                  hintText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  //
                  sendPushNotification(
                    _titleController.text.trim(),
                    _messageController.text.trim(),
                  );
                },
                child: const Text('Sent'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  // static Future<void> getFirebaseMessagingToken() async {
  // await fMessaging.requestPermission();
  //
  // await fMessaging.getToken().then((t) {
  //   if (t != null) {
  //     // me.pushToken = t;
  //     log('Push Token: $t');
  //   }
  // });

  // send
  // sendPushNotification(
  // _titleController.text.trim(),
  // _messageController.text.trim(),
  // );

  // }
// for sending push notification
  Future<void> sendPushNotification(String title, String msg) async {
    try {
      final body = {
        "to":
            'cesHzOwkTQ26YcZnW-pqcz:APA91bFFoRvTzn_19giKaQXKN4XPbC9V0dXae32bdWkNK35eMSyLS1pbCqqR6K9qIrAeRx0FtSApqvBvPq1xFg6kaAsJuem0qoaH9spdEJP1S4Q9AmjxwCnbngPsI6CMm1wAieY481FH',
        "notification": {
          "title": title, //our name should be send
          "body": msg,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
      };

      //
      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAJ3jraTs:APA91bHWfyErZWnPrFaNKS3GU568MECGA987ZSkGwqWlTscJWwXJ9dEZC-tOWtdno4KOi50ewzHlmuRbfB7e-UTw8Lmb0_o-TU9CZQqww9Pjh10EnLBjgv34208ZJNf6zlvTizOSq3V4'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
