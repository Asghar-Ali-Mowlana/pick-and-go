import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initializeSettings;

  NotificationService.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatform();
    tz.initializeTimeZones();
    //tz.initializeTimeZones();
    //displayNotification();
  }

  initializePlatform() {
    var initializeAndroid = AndroidInitializationSettings('logo');
    initializeSettings = InitializationSettings(android: initializeAndroid);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    //DidReceiveLocalNotificationCallback.listen()
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializeSettings);
  }

  Future<void> showNotification() async {
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        enableLights: true);
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.show(0, 'Operational Center',
        'Assign operational center driver before 7 PM', platformChannel,
        payload: 'New_Payload');
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 5));
    var time = Time(18, 45, 00);
    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        enableLights: true);
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Operational Center',
      'Assign a driver before 7 PM',
      time,
      platformChannel,
      payload: 'New_Payload',
      //uiLocalNotificationDateInterpretation:
      //  UILocalNotificationDateInterpretation.absoluteTime,
      //androidAllowWhileIdle: true
    );
  }
}

NotificationService notificationService = NotificationService.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceiveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
