import 'dart:async';

import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:Metronomy/model/constants.dart';

import 'package:Metronomy/store/rhythm_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundToggleButton extends ConsumerStatefulWidget {

  final Function setStateCallback;

  final AudioPlayer audioPlayerHighPitchedSound = AudioPlayer()
    ..setPlayerMode(
      PlayerMode.lowLatency,
    );
  final AudioPlayer audioPlayerLowPitchedSound = AudioPlayer()
    ..setPlayerMode(
      PlayerMode.lowLatency,
    );

  SoundToggleButton({super.key, required this.setStateCallback});

  static Duration getRhythmInterval(int rhythm) =>
      Duration(microseconds: (((60 / rhythm) * 1000)* 1000).toInt());

  @override
  ConsumerState<SoundToggleButton> createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends ConsumerState<SoundToggleButton> {

  Timer? periodicTimer;
  int oldValuePrint = 0;

  Duration? tempoDuration;

  @override
  void dispose() {
    this.widget.audioPlayerHighPitchedSound.dispose();
    this.widget.audioPlayerLowPitchedSound.dispose();

    periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    tempoDuration = SoundToggleButton.getRhythmInterval(RhythmProvider.of(context).rhythm) as Duration;

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

  @override
  void didChangeDependencies() {

    tempoDuration = SoundToggleButton.getRhythmInterval(RhythmProvider.of(context).rhythm) as Duration;

    periodicTimer?.cancel();
    periodicTimer = Timer.periodic(
      // récupérer la valeur courante du rythme
      tempoDuration!,
          (_) {
            final bool firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
            //final bool firstSongDifferent = true;
            _printMaintenant();

            if (RhythmStore.of(context).enable) {

              RhythmProvider.of(context).updateMakeCountdown();

              if (RhythmStore.of(context).debugTickCount > 0) {
                if(firstSongDifferent && RhythmProvider.of(context).debugTickCount % RhythmProvider.of(context).selectedSong.beatsByBar == 0){
                  // case occures when this is the first tick as mesure / bar (aka modulo == 0)
                  playHighSound();
                }else{
                  // case occures when startingCountdown == 0, debugTickCount > 0 (ie : time 2, 3, 4, 6, 7, 8, 10, 11, 12, 14, ...)
                  playLowSound();
                }
              }else {
                if(RhythmProvider.of(context).startingCountdown == 0 && RhythmProvider.of(context).debugTickCount > 0) {
                  // case occures when startingCountdown == 0, debugTickCount = 0 (time 1)
                  if(firstSongDifferent){
                    playHighSound();
                  } else {
                    playLowSound();
                  }
                } else {
                  // case occures when startingCountdown > 0, debugTickCount = 0 (time -9, -8, -7, -6, -5, -4, -3, -2, -1, 0)
                  playLowSound();
                }
              }
            }
            this.widget.setStateCallback();
      },
    );
    super.didChangeDependencies();
  }


  void playLowSound() {
    this.widget.audioPlayerLowPitchedSound.pause();
    this.widget.audioPlayerLowPitchedSound.seek(Duration.zero);
    this.widget.audioPlayerLowPitchedSound.play(songB);
  }

  void playHighSound() {
    this.widget.audioPlayerHighPitchedSound.pause();
    this.widget.audioPlayerHighPitchedSound.seek(Duration.zero);
    this.widget.audioPlayerHighPitchedSound.play(songA);
  }

  void _printMaintenant() {

    var nowDT = DateTime.now();
    var nowMicrosecondsSinceEpoch = nowDT.microsecondsSinceEpoch;
    int gradian = nowMicrosecondsSinceEpoch - oldValuePrint;

    print('${nowDT} // ${gradian /1000} microsec');

    oldValuePrint = nowMicrosecondsSinceEpoch;
  }

  void refreshTempoDuration(BuildContext context){
    tempoDuration = SoundToggleButton.getRhythmInterval(RhythmProvider.of(context).rhythm);
    RhythmProvider.of(context).updateStopTimer();
  }
}