import 'dart:async';

import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {

  final Function setStateCallback;

  const StopButton({super.key, required this.setStateCallback});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //backgroundColor: Theme.of(context).colorScheme.primary,
      enableFeedback: false,
      onPressed: () {
        RhythmProvider.of(context).updateStopTimer();
        setStateCallback();
      },
      tooltip: 'Stop',
      child: Icon(Icons.stop),
    );
  }
}