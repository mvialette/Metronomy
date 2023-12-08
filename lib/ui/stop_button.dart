import 'dart:async';

import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {

  final Function setStateCallback;

  const StopButton({super.key, required this.setStateCallback});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      enableFeedback: false,
      onPressed: () {
        RhythmProvider.of(context).updateStopTimer();
        setStateCallback();
      },
      tooltip: 'Stop',
      backgroundColor: Colors.orangeAccent,
      child: Icon(Icons.stop),
    );
  }
}