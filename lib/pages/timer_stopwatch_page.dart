import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/notification_service.dart';

class TimerStopwatchPage extends StatefulWidget {
  @override
  _TimerStopwatchPageState createState() => _TimerStopwatchPageState();
}

class _TimerStopwatchPageState extends State<TimerStopwatchPage> {
  int _seconds = 0;
  bool _isRunning = false;
  bool _isTimerRunning = false;
  Stopwatch _stopwatch = Stopwatch();
  final TextEditingController _timerController = TextEditingController();
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.initializeNotifications();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
    });
    _updateTime();
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.reset();
    });
  }

  void _updateTime() {
    if (_isRunning) {
      setState(() {});
      Future.delayed(Duration(milliseconds: 30), _updateTime);
    }
  }

  void _startTimer() {
    if (_timerController.text.isNotEmpty) {
      setState(() {
        _seconds = int.tryParse(_timerController.text) ?? 0;
        _isTimerRunning = true;
      });
      _updateTimer();
    }
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _isTimerRunning = false;
    });
  }

  void _updateTimer() {
    if (_seconds > 0 && _isTimerRunning) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _seconds--;
        });
        _updateTimer();
      });
    } else if (_seconds == 0 && _isTimerRunning) {
      _notificationService.showNotification();
      _resetTimer(); // Reset the timer when it reaches 0
    }
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (hours > 0) {
      return '$hours 시간 $minutes 분 $seconds 초';
    } else if (minutes > 0) {
      return '$minutes 분 $seconds 초';
    } else {
      return '$seconds 초';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타이머 & 스탑워치'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _timerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '타이머 시간 초를 입력하세요'),
            ),
            SizedBox(height: 20),
            Text(
              '타이머: ${_formatTime(_seconds)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('타이머 시작'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('타이머 정지'),
                ),
              ],
            ),
            SizedBox(height: 40),
            Divider(height: 40, thickness: 2),
            Text(
              '스탑워치: ${_stopwatch.elapsed.inMinutes}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}.${(_stopwatch.elapsed.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isRunning ? _stopStopwatch : _startStopwatch,
                  child: Text(_isRunning ? '정지' : '시작'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Text('초기화'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
