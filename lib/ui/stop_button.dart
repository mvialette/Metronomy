import 'dart:async';

import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';
import 'package:Metronomy/providers/audio_player_provider.dart';
import 'package:Metronomy/model/constants.dart';

// importer RhythmStore
import 'package:Metronomy/store/rhythm_store.dart';

class StopButton extends StatelessWidget {
  const StopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      enableFeedback: false,
      onPressed: () {
        RhythmProvider.of(context).updateEnableTimer(false);
        /*setState(() {

        });*/
      },
      tooltip: 'Stop',
      backgroundColor: Colors.orangeAccent,
      child: Icon(Icons.stop),
      //child: Icon(_timerBPM != null && _timerBPM!.isActive ? Icons.pause : Icons.play_arrow),
    );
  }
}