import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  Timer? _timer;
  List<String> _laps = [];
  String _formattedTime = "00:00.000";

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {
        _formattedTime = _formatDuration(_stopwatch.elapsed);
      });
    });
  }

  void _startStopwatch() {
    _stopwatch.start();
    _startTimer();
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _timer?.cancel();
    _formattedTime = "00:00.000";
    _laps.clear();
    setState(() {});
  }

  void _lap() {
    setState(() {
      _laps.insert(0, _formatDuration(_stopwatch.elapsed));
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds =
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0');
    return "$minutes:$seconds.$milliseconds";
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
        title: const Text("Stopwatch"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formattedTime,
            style: const TextStyle(
              fontSize: 60,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                    _stopwatch.isRunning ? _stopStopwatch : _startStopwatch,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _resetStopwatch,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Reset'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _stopwatch.isRunning ? _lap : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Lap'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "Lap ${_laps.length - index}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    _laps[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
