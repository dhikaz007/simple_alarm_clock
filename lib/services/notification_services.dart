// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/alarm_model.dart';
import '../provider/alarm_provider.dart';
import '../screens/chart_page.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload!.isNotEmpty) {
          if (details.payload == 'chart') {
            showBarChart(context);
          }
        }
      },
    );
  }

  Future<void> setNotificationAlarm(int hour, int minute) async {
    // Configure the alarm notification
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Notification',
      channelDescription: 'Channel for Alarm Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Set the alarm time
    final now = DateTime.now();
    var alarmTime = DateTime(now.year, now.month, now.day, hour, minute);

    // Ensure the alarm time is in the future
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    // Show Notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm',
      'Time to wake up!',
      tz.TZDateTime.from(alarmTime, tz.local),
      platformChannelSpecifics,
      payload: 'chart',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void showBarChart(BuildContext context) {
    List<AlarmModel> alarms =
        Provider.of<AlarmProvider>(context, listen: false).alarm;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ChartPage(alarm: alarms),
      ),
    );
  }
}
