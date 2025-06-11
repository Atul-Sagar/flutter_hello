import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _seconds = 60;
  int _initialSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initializeNotifications() async{
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'timer_channel_id',
      'Timer Notifications',
      channelDescription: 'Notifies when timer finishes',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Timer Finished',
      'Your countdown has ended.',
      platformChannelSpecifics,
      payload: 'timer_complete',
    );
  }


  void _requestNotificationPermission() async {
    final plugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final granted = await plugin?.requestNotificationsPermission();
    print('Notification permission granted: $granted');


  }

  Future<void> _testNotification() async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'Test Notification',
    'This is a test notification.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestNotificationPermission();
  }

  void _startTimer() async {

    await _testNotification();

    if (_timer != null) _timer!.cancel();

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        timer.cancel();
        setState(() => _isRunning = false);
        await _showNotification();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = _initialSeconds;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Timer'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(_seconds),
                style: const TextStyle(color: Colors.white, fontSize: 60),
              ),
              const SizedBox(height: 10),

              // ✅ Seconds counter display
              Text(
                '$_seconds seconds',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),

              Slider(
                value: _seconds.toDouble(),
                min: 0,
                max: 600,
                divisions: 60,
                label: '$_seconds s',
                activeColor: Colors.indigo,
                onChanged: _isRunning
                    ? null
                    : (value) {
                        setState(() {
                          _seconds = value.toInt();
                          _initialSeconds = _seconds;
                        });
                      },
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isRunning ? null : _startTimer,
                    child: const Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: _isRunning ? _stopTimer : null,
                    child: const Text('Stop'),
                  ),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    child: const Text('Reset'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
