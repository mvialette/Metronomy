import 'dart:async';

import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';
import 'package:Metronomy/providers/audio_player_provider.dart';
import 'package:Metronomy/model/constants.dart';

import 'package:Metronomy/store/rhythm_store.dart';

class SoundToggleButton extends StatefulWidget {
  const SoundToggleButton({super.key});

  static Duration getRhythmInterval(int rhythm) =>
      Duration(milliseconds: ((60 / rhythm) * 1000).toInt());

  @override
  State<SoundToggleButton> createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends State<SoundToggleButton> {
  Timer? periodicTimer;
  int oldValuePrint = 0;

  bool a = false;
  bool b = false;
  bool c = false;
  bool d = false;

  @override
  void didChangeDependencies() {
    final audioPlayer = AudioPlayerProvider.of(context).audioPlayer;
    periodicTimer?.cancel();
    periodicTimer = Timer.periodic(
      // récupérer la valeur courante du rythme
      SoundToggleButton.getRhythmInterval(RhythmStore.of(context).rhythm),
          (_) {
        _printMaintenant();
        if (RhythmStore.of(context).enable) {
          RhythmProvider.of(context).updateDowngradeCountdown();

          audioPlayer.pause();
          audioPlayer.seek(Duration.zero);

          if (!a) {
            a = !a;
          } else if (!b) {
            b = !b;
          } else if (!c) {
            c = !c;
          } else if (!d) {
            d = !d;
          } else {
            a = true;
            b = false;
            c = false;
            d = false;
          }

          if(a == true && b == false && c == false && d == false){
            audioPlayer.play(songA);
          }else{
            audioPlayer.play(songB);
          }
        }
      },
    );
    super.didChangeDependencies();
  }

  void _printMaintenant() {
    var nowDT = DateTime.now();
    var nowMicrosecondsSinceEpoch = nowDT.microsecondsSinceEpoch;
    int gradian = nowMicrosecondsSinceEpoch - oldValuePrint;

    print('${nowDT} // ${gradian /1000} microsec');
    oldValuePrint = nowMicrosecondsSinceEpoch;
  }

  @override
  void dispose() {
    final audioPlayer = AudioPlayerProvider.of(context).audioPlayer;
    audioPlayer.dispose();

    periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      enableFeedback: false,
      onPressed: () {
        setState(() {
          RhythmProvider.of(context).updateEnableTimer(!RhythmStore.of(context).enable);
        });
      },
      tooltip: 'Play',
      backgroundColor: Colors.orangeAccent,
      child: Icon(
        RhythmStore.of(context).enable ? kPauseIcon : kPlayIcon,
      ),
    );
  }
}