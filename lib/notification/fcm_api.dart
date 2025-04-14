import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:priyobanskhali/screens/home/book/see_more_book.dart';

import '/admin/orders/orders.dart';
import '/screens/dashboard.dart';
import '../screens/blog/blog_screen.dart';
import '../screens/home/ebook/see_more_ebook.dart';
import 'notification_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Background FCM: ${message.notification?.title}');
}

class FcmApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  final localNotifications = FlutterLocalNotificationsPlugin();

  final channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
  );

  Future<void> initPushNotifications() async {
    await firebaseMessaging.requestPermission();

    // Handle when app launched from terminated state
    final initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    //
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final data = message.data;
      final imageUrl = data['image'];
      final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

      if (notification != null) {
        if (hasImage) {
          _downloadAndShowImageNotification(notification, data, imageUrl);
        } else {
          _showSimpleNotification(notification, data);
        }
      }
    });

    await _subscribeToTopics();
    await initLocalPushNotifications();
  }

  Future<void> _subscribeToTopics() async {
    await firebaseMessaging.subscribeToTopic('blog');
    await firebaseMessaging.subscribeToTopic('book');
    await firebaseMessaging.subscribeToTopic('ebook');
    await firebaseMessaging.subscribeToTopic('notifications');
  }

  Future<void> initLocalPushNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/logo'),
    );

    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          print("Clicked notification: $data");
          _handleNavigation(data);
        }
      },
    );

    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(channel);
  }

  void handleMessage(RemoteMessage message) {
    final data = message.data;
    print('🔔 [HANDLE] FCM Message: ${jsonEncode(data)}');
    _handleNavigation(data);
  }

  void _handleNavigation(Map<String, dynamic> data) {
    final type = data['type'];
    print("🔔 Navigation type: $type");

    switch (type) {
      case 'blog':
        Get.to(() => const BlogScreen());
        break;
      case 'book':
        Get.to(() => const SeeMoreBook(
              categoryName: 'new',
            ));
        break;
      case 'ebook':
        Get.to(() => const SeeMoreEbook(categoryName: 'new'));
        break;
      case 'notifications':
        Get.to(() => const NotificationScreen());
      case 'orders':
        Get.to(() => const Orders());

        break;
      default:
        Get.to(() => const Dashboard());
    }
  }

  Future<void> _downloadAndShowImageNotification(
    RemoteNotification notification,
    Map<String, dynamic> data,
    String imageUrl,
  ) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/fcm_image.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      final bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(filePath),
        contentTitle: notification.title,
        summaryText: notification.body,
      );

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/logo',
        styleInformation: bigPictureStyle,
      );

      await localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(android: androidDetails),
        payload: jsonEncode(data),
      );
    } catch (e) {
      print('⚠️ Failed to load image: $e');
      _showSimpleNotification(notification, data);
    }
  }

  void _showSimpleNotification(
    RemoteNotification notification,
    Map<String, dynamic> data,
  ) {
    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/logo',
    );

    localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails),
      payload: jsonEncode(data),
    );
  }
}
