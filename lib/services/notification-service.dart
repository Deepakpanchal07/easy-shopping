import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:e_commerce/screens/user-panel/notification-screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      Get.snackbar(
        'Notification Permission Denied',
        'Please allow notifications to receive updates.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  // Get Device Token
  Future<String> getDeviceToken() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    String? token = await messaging.getToken();
    print("FCM Token => $token");
    return token!;
  }

  // Initialize local notifications
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInit =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInit = const DarwinInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        handleMessage(context, message);
      },
    );
  }

  /// Firebase Messaging initialization
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("Notification Received");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
      }

      if (Platform.isIOS) iosForegroundSettings();
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  /// Show notification
  Future<void> showNotification(RemoteMessage message) async {
    String channelId =
        message.notification?.android?.channelId ?? 'default_channel';
    String channelName = 'Important Notifications';

    var androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    var androidDetails = AndroidNotificationDetails(
      androidChannel.id,
      androidChannel.name,
      channelDescription: "For important notifications",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    var iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      notificationDetails,
      payload: "my_data",
    );
  }

  // Handle background & terminated notifications
  Future<void> setupInteractMessage(BuildContext context) async {
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });

    // Terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });
  }

  // Navigate when notification clicked
  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    print(
        "navigating to appointment screens hit here to handle message. Message data: ${message.data}");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationScreen(message: message)));
  }

  Future<void> iosForegroundSettings() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
