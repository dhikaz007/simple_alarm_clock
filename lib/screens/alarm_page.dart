// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/alarm_model.dart';
import '../provider/alarm_provider.dart';
import 'chart_page.dart';
import 'widget/clock_painter_widget.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  int hour = 12;
  int minute = 3;
  DateTime timeNow = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
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

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChartPage(alarm: alarms),
        ));
  }

  @override
  void initState() {
    initNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.sizeOf(context).width;
    final alarmProv = Provider.of<AlarmProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text(
                'Set the alarm',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                '${alarmProv.hour.toString().padLeft(2, '0')}:${alarmProv.minute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async => await showTimePicker(
                  context: context,
                  initialTime: currentTime,
                  initialEntryMode: TimePickerEntryMode.dialOnly,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true,
                    ),
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
                icon: const Icon(
                  Icons.alarm_rounded,
                  size: 40,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                height: 200,
                child: Consumer<AlarmProvider>(
                  builder: (context, value, child) => GestureDetector(
                    // onPanUpdate: (details) {
                    //   if (details.delta.dx.abs() > details.delta.dy.abs()) {
                    //     // Horizontal drag (change minutes)

                    //     minute = (value
                    //         .changeMinute(
                    //             value.minute + details.delta.dx.toInt())
                    //         .clamp(0, 59));
                    //   } else {
                    //     // Vertical drag (change hours)

                    //     hour = (value
                    //         .changeHour(value.hour + details.delta.dy.toInt())
                    //         .clamp(1, 12));
                    //   }
                    // },
                    onVerticalDragUpdate: (details) {
                      hour = (value
                              .changeHour(value.hour + details.delta.dy.toInt())
                              .clamp(0, 23)) %
                          12;
                    },
                    onHorizontalDragUpdate: (details) {
                      minute = (value
                          .changeMinute(value.minute + details.delta.dx.toInt())
                          .clamp(0, 59));
                    },
                    child: CustomPaint(
                      painter: ClockPainterWidget(
                        hours: alarmProv.hour,
                        minutes: alarmProv.minute,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: widthSize,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.all(12),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    FlutterAlarmClock.createAlarm(
                      hour: alarmProv.hour,
                      minutes: alarmProv.minute,
                    );
                    setNotificationAlarm(
                      alarmProv.hour,
                      alarmProv.minute,
                    );
                  },
                  child: Text(
                    'Set the alarm',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => FlutterAlarmClock.showAlarms(),
        icon: const Icon(
          Icons.alarm_add_rounded,
          size: 28,
        ),
        label: Text(
          'Show alarm status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
