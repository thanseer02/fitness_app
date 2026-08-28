import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerDialog extends StatefulWidget {
  final int initialSeconds;

  const RestTimerDialog({super.key, this.initialSeconds = 60});

  @override
  State<RestTimerDialog> createState() => _RestTimerDialogState();
}

class _RestTimerDialogState extends State<RestTimerDialog> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_secondsLeft / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');

    return AlertDialog(
      title: const Text('Rest Timer', textAlign: TextAlign.center),
      content: Text(
        '$minutes:$seconds',
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).pop();
          },
          child: const Text('Skip Rest'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
