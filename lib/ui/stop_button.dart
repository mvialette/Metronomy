import 'dart:async';

import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {
  const StopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      enableFeedback: false,
      onPressed: () {
        RhythmProvider.of(context).updateStopTimer();
      },
      tooltip: 'Stop',
      backgroundColor: Colors.orangeAccent,
      child: Icon(Icons.stop),
    );
  }
}