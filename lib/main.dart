import 'package:flutter/material.dart';
import 'pages/timer_stopwatch_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '타이머 & 스탑워치',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerStopwatchPage(),
    );
  }
}
