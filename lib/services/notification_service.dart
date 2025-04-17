import 'dart:convert';
import 'dart:io';

import 'package:ciputra_patroli/services/firebase_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseService _firebaseService = FirebaseService();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> allTokens = [];

  NotificationService() {
    _initializeLocalNotifications();
    _initializeFirebaseMessaging();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    _showNotification(message.notification?.title, message.notification?.body);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print(
        "Message received in foreground: ${message.notification?.title} - ${message.notification?.body}");
    _showNotification(message.notification?.title, message.notification?.body);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print(
        "Message opened from background: ${message.notification?.title} - ${message.notification?.body}");
    _showNotification(message.notification?.title, message.notification?.body);
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');
  }

  Future<void> sendNotificationToAll(String title, String message) async {
    allTokens = await _firebaseService.getAllFCMTokens();

    for (String token in allTokens) {
      await sendNotification(token, title, message);
    }
  }

  Future<void> sendNotification(
      String token, String title, String message) async {
    final credentials = json.decode(
        await rootBundle.loadString('assets/firebase-credentials.json'));

    final authClient = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(credentials),
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/ciputrapatroli/messages:send');

    final response = await authClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "message": {
          "token": token,
          "notification": {"title": title, "body": message},
          "android": {
            "priority": "HIGH",
            "notification": {"sound": "default"}
          },
          "apns": {
            "payload": {
              "aps": {
                "alert": {"title": title, "body": message},
                "sound": "default",
                "content-available": 1
              }
            }
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully: ${response.body}');
    } else {
      print(
          'Failed to send notification: ${response.statusCode} ${response.body}');
    }
  }
}
