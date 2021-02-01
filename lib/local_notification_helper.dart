import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationHelper {
  NotificationHelper({@required this.context});

  FlutterLocalNotificationsPlugin flutterLocalNotifications;
  final BuildContext context;

  void initLocalNotification() {
    var androidInit = AndroidInitializationSettings('app_icon');
    var iosInit = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    flutterLocalNotifications = FlutterLocalNotificationsPlugin();
    flutterLocalNotifications.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
  }

  // ignore: missing_return
  Future notificationSelected(String payload) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Notification TIKLANDI $payload'),
        );
      },
    );
  }

  showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'Channel ID',
      'TayyaR',
      'Tanım',
      importance: Importance.max,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotifications.show(
        Random().nextInt(pow(2, 31)), 'Title', 'BODY', generalNotificationDetails,
        payload: 'HEYO');
  }

  void cancelNotificationAll() async {
    await flutterLocalNotifications.cancelAll();
  }

  void scheduledTile(String payload, {@required Duration duration}) async {
    var androidDetails = AndroidNotificationDetails(
      'Channel ID',
      'TayyaR',
      'Tanım',
      enableLights: true,
      importance: Importance.max,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotifications.zonedSchedule(Random().nextInt(pow(2, 31)), 'title',
        'body', tz.TZDateTime.now(tz.local).add(duration), generalNotificationDetails,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  void scheduledTask(String payload) async {
    var androidDetails = AndroidNotificationDetails(
      'Channel ID',
      'TayyaR',
      'Tanım',
      importance: Importance.max,
    );
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotifications.zonedSchedule(
        Random().nextInt(pow(2, 31)),
        'title',
        'body',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
        generalNotificationDetails,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  // ignore: always_declare_return_types
  tarihli(String payload, TZDateTime dateTime) async {
    var androidDetails = AndroidNotificationDetails('Channel ID1z', 'TayyaR1z', 'Tanım1z',
        importance: Importance.max);
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    print('TARIHLI');
    var id = Random().nextInt(pow(2, 31));
    print('id : $id');
    print(tz.local);

    var year = DateTime.now().year;
    var month = DateTime.now().month;
    var day = DateTime.now().day;
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;
    var sec = DateTime.now().second + 5;

    await flutterLocalNotifications.zonedSchedule(
        id,
        'title',
        'body',
         dateTime,

        //tz.TZDateTime.utc(year,month,day,hour,minute,sec),
        generalNotificationDetails,
        uiLocalNotificationDateInterpretation: null,
        androidAllowWhileIdle: true);
  }
}
