import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart';
import 'local_notification_helper.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationHelper _helper;
  TextEditingController _editingController;
  String localTimeZone = 'Unknown';

  @override
  void initState() {
    super.initState();
    _helper = NotificationHelper(
      context: context,
    );
    _helper.initLocalNotification();
    _editingController = TextEditingController();
    _getNativeTimeZone();
  }

  void _getNativeTimeZone() async {
    String tzz;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      tzz = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      tzz = 'Failed to get the timezone.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      localTimeZone = tzz;
    });
  }

//'America/Noronha'
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          print(localTimeZone);
        },
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 50,
              child: TextFormField(
                controller: _editingController,
                keyboardType: TextInputType.number,
              ),
            ),
            RaisedButton(
                child: Text('PUSH'),
                onPressed: () {
                  _helper.showNotification();
                }),
            RaisedButton(
              child: Text('PUSH SPECIFIC SEC'),
              onPressed: () {
                var istanbul = tz.getLocation('Europe/Istanbul');
                tz.setLocalLocation(istanbul);
                // _helper.scheduledTask('HEY HEY');

                var sec = int.parse(_editingController.text);
                _helper.scheduledTile('\nPAYLOAD: $sec second ',
                    duration: Duration(seconds: sec));
              },
            ),
            RaisedButton(
              child: Text('PUSH SPECIFIC MIN'),
              onPressed: () {
                var istanbul = tz.getLocation('Europe/Istanbul');
                tz.setLocalLocation(istanbul);
                // _helper.scheduledTask('HEY HEY');

                var min = int.parse(_editingController.text);
                _helper.scheduledTile('\nPAYLOAD: $min second ',
                    duration: Duration(minutes: min));
              },
            ),
            RaisedButton(
              onPressed: () {
                var year = DateTime.now().year;
                var month = DateTime.now().month;
                var day = DateTime.now().day;
                var hour = DateTime.now().hour;
                var minute = DateTime.now().minute;
                var sec = DateTime.now().second + 5;

                var dateTime = DateTime(year, month, day, hour, minute, sec);
               

                var time = tz.TZDateTime.from(dateTime, tz.getLocation(localTimeZone));

                _helper.tarihli('YÜK', time);
              },
              child: Text('Tarihli'),
            ),
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                _helper.cancelNotificationAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
