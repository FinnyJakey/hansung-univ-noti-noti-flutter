import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../providers/fcm/fcm_provider.dart';

class FirebaseService {
  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging =>
      FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

  static Future<void> initializeFirebase() async {
    FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseService.initializeLocalNotifications();
    await FirebaseService.onMessage();
    await FirebaseService.onBackgroundMsg();
  }

  static Future<String?> getDeviceToken() async =>
      await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BIo63VK3b3RMPKxIxB5RybDXiXYCMClNgC2qPcCVLOUVYybI7ZsxQCS5tnF3r63ZJPgQz06PzESKKLuWCZmjElg");

  static Future<void> deleteDeviceToken() async =>
      await FirebaseMessaging.instance.deleteToken();

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications() async {
    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/push_logo"),
      iOS: DarwinInitializationSettings(),
    );
    await FirebaseService._localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: FCMProvider.onTapNotification);

    /// need this for ios foregournd notification
    await FirebaseService.firebaseMessaging
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  static NotificationDetails platformChannelSpecifics =
      const NotificationDetails(
    android: AndroidNotificationDetails(
      "high_importance_channel",
      "High Importance Notifications",
      priority: Priority.max,
      importance: Importance.max,
    ),
    iOS: DarwinNotificationDetails(),
  );
  // for receiving message when app is in background or foreground
  static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        if (Platform.isAndroid) {
          // if this is available when Platform.isIOS, you'll receive the notification twice
          await FirebaseService._localNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            FirebaseService.platformChannelSpecifics,
            payload: message.data.toString(),
          );
        }
      },
    );
  }

  static Future<void> onBackgroundMsg() async {
    FirebaseMessaging.onBackgroundMessage(FCMProvider.backgroundHandler);
  }

  static sendAvailableMessage(String body) async {
    await FirebaseService._localNotificationsPlugin.show(
      0,
      "한성대 노티노티",
      body,
      FirebaseService.platformChannelSpecifics,
    );
  }
}
