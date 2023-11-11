import 'dart:async';

import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/providers/songs_provider.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:Metronomy/providers/audio_player_provider.dart';
import 'package:Metronomy/model/constants.dart';

import 'package:Metronomy/store/rhythm_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundToggleButton extends ConsumerStatefulWidget {
  const SoundToggleButton({super.key});

  static Duration getRhythmInterval(int rhythm) =>
      Duration(microseconds: (((60 / rhythm) * 1000)* 1000).toInt());

  @override
  ConsumerState<SoundToggleButton> createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends ConsumerState<SoundToggleButton> {
  Timer? periodicTimer;
  int oldValuePrint = 0;

  bool _timeOne = false;
  bool _timeTwo = false;
  bool _timeThree = false;
  bool _timeFour = false;

  AudioPlayer? audioPlayer;

  /*@override
  void initState() {
    super.initState();
    _timeOne = RhythmStore.of(context).timeOne;
    _timeTwo = RhythmStore.of(context).timeTwo;
    _timeThree = RhythmStore.of(context).timeThree;
    _timeFour = RhythmStore.of(context).timeFour;
  }*/
  /*@override
  void didChangeDependencies() {
    final audioPlayer = AudioPlayerProvider.of(context).audioPlayer;


    periodicTimer?.cancel();
    periodicTimer = Timer.periodic(
      // récupérer la valeur courante du rythme
      SoundToggleButton.getRhythmInterval(RhythmStore.of(context).rhythm),
          (_) {
          final bool firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
        _printMaintenant();
        if (RhythmStore.of(context).enable) {
          RhythmProvider.of(context).updateMakeCountdown();

          audioPlayer.pause();
          audioPlayer.seek(Duration.zero);

          if (RhythmStore.of(context).debugTickCount > 0) {
            if(RhythmStore.of(context).timeOne && RhythmStore.of(context).timeTwo && RhythmStore.of(context).timeThree && RhythmStore.of(context).timeFour){
              // case occures when startingCountdown == 0, debugTickCount > 0 (ie : time 5, 9, 13, ...)

              if(firstSongDifferent){
                audioPlayer.play(songA);
              }else{
                audioPlayer.play(songB);
              }
            }else{
              // case occures when startingCountdown == 0, debugTickCount > 0 (ie : time 2, 3, 4, 6, 7, 8, 10, 11, 12, 14, ...)
              audioPlayer.play(songB);
            }
          }else {
            if(RhythmStore.of(context).startingCountdown == 0) {
              // case occures when startingCountdown == 0, debugTickCount = 0 (time 1)
              //audioPlayer.play(songA);
              if(firstSongDifferent){
                audioPlayer.play(songA);
              }else{
                audioPlayer.play(songB);
              }
            } else {
              // case occures when startingCountdown > 0, debugTickCount = 0 (time -9, -8, -7, -6, -5, -4, -3, -2, -1, 0)
              audioPlayer.play(songB);
            }
          }
        }
      },
    );
    super.didChangeDependencies();
  }*/

  void _printMaintenant() {
    /*songsAvailable = ref.watch(songsProvider);
    //RhythmProvider.of(context).updateMusicSection(myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBeatSection, myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBarsSection);
    myCurrentSong = songsAvailable[0];
    //RhythmProvider.of(context).updateMusicSection(myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBeatSection, myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBarsSection);
    myCurrentSong = songsAvailable[0];
    print('b${myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBeatSection}');
    print('bb${myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBarsSection}');*/

    var nowDT = DateTime.now();
    var nowMicrosecondsSinceEpoch = nowDT.microsecondsSinceEpoch;
    int gradian = nowMicrosecondsSinceEpoch - oldValuePrint;

    print('${nowDT} // ${gradian /1000} microsec');
    // print('${nowDT} // ${gradian /1000} microsec - ${intervalInMicrosecond /1000}  microsec = ${(gradian - intervalInMicrosecond) / 1000}  millisecondes ');

    oldValuePrint = nowMicrosecondsSinceEpoch;
  }

  @override
  void dispose() {
    audioPlayer = AudioPlayerProvider.of(context).audioPlayer;
    //audioPlayer.dispose();

    periodicTimer?.cancel();
    super.dispose();
  }
/*
  @override
  void initState() {
    audioPlayer = AudioPlayerProvider.of(context).audioPlayer;
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    _timeOne = RhythmStore.of(context).timeOne;
    _timeTwo = RhythmStore.of(context).timeTwo;
    _timeThree = RhythmStore.of(context).timeThree;
    _timeFour = RhythmStore.of(context).timeFour;

    audioPlayer = AudioPlayerProvider.of(context).audioPlayer;

    return Row(
      children: [

            Icon(
              _timeOne?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            Icon(_timeTwo?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
            Icon(_timeThree?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
            Icon(_timeFour?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),


        FloatingActionButton(
          enableFeedback: false,
          tooltip: 'Play',
          backgroundColor: Colors.orangeAccent,
          child: Icon(
            RhythmStore.of(context).enable ? kPauseIcon : kPlayIcon,
          ),
          onPressed: () {


            periodicTimer?.cancel();
            periodicTimer = Timer.periodic(
            // récupérer la valeur courante du rythme
            SoundToggleButton.getRhythmInterval(RhythmStore.of(context).rhythm),
            (_) {
              //if (RhythmStore.of(context).enable) {
                final bool firstSongDifferent =
                    ref.read(allSettingsProvider).firstSongDifferent;
                audioPlayer?.pause();
                audioPlayer?.seek(Duration.zero);

                if (_timeOne) {
                  _timeOne = false;
                  _timeTwo = true;
                } else if (_timeTwo) {
                  _timeTwo = false;
                  _timeThree = true;
                } else if (_timeThree) {
                  _timeThree = false;
                  _timeFour = true;
                } else {
                  _timeFour = false;
                  _timeOne = true;
                }
                if (firstSongDifferent) {
                  if (_timeOne) {
                    audioPlayer?.play(songA);
                  } else {
                    audioPlayer?.play(songB);
                  }
                } else {
                  audioPlayer?.play(songB);
                }

                setState(() {
                  RhythmProvider.of(context).updateMakeCountdown2();
                  if (_timeOne) {
                    _timeOne = false;
                    _timeTwo = true;
                  } else if (_timeTwo) {
                    _timeTwo = false;
                    _timeThree = true;
                  } else if (_timeThree) {
                    _timeThree = false;
                    _timeFour = true;
                  } else {
                    _timeFour = false;
                    _timeOne = true;
                  }
                });
              }
            });

            /*
              RhythmProvider.of(context).updateEnableTimer(!RhythmStore.of(context).enable);
              final audioPlayer = AudioPlayerProvider.of(context).audioPlayer;

              periodicTimer?.cancel();
              periodicTimer = Timer.periodic(
                // récupérer la valeur courante du rythme
                SoundToggleButton.getRhythmInterval(RhythmStore.of(context).rhythm),
                    (_) {
                      _timeOne = !_timeOne;
                      _timeTwo = !_timeTwo;
                      _timeOne = !_timeOne;
                      _timeOne = !_timeOne;

                  _printMaintenant();
                  if (RhythmStore.of(context).enable) {
                    RhythmProvider.of(context).updateMakeCountdown();

                    audioPlayer.pause();
                    audioPlayer.seek(Duration.zero);

                    if (RhythmStore.of(context).debugTickCount > 0) {
                      if(RhythmStore.of(context).timeOne && RhythmStore.of(context).timeTwo && RhythmStore.of(context).timeThree && RhythmStore.of(context).timeFour){
                        // case occures when startingCountdown == 0, debugTickCount > 0 (ie : time 5, 9, 13, ...)

                        if(firstSongDifferent){
                          audioPlayer.play(songA);
                        }else{
                          audioPlayer.play(songB);
                        }
                      }else{
                        // case occures when startingCountdown == 0, debugTickCount > 0 (ie : time 2, 3, 4, 6, 7, 8, 10, 11, 12, 14, ...)
                        audioPlayer.play(songB);
                      }
                    }else {
                      if(RhythmStore.of(context).startingCountdown == 0) {
                        // case occures when startingCountdown == 0, debugTickCount = 0 (time 1)
                        //audioPlayer.play(songA);
                        if(firstSongDifferent){
                          audioPlayer.play(songA);
                        }else{
                          audioPlayer.play(songB);
                        }
                      } else {
                        // case occures when startingCountdown > 0, debugTickCount = 0 (time -9, -8, -7, -6, -5, -4, -3, -2, -1, 0)
                        audioPlayer.play(songB);
                      }
                    }
                  }
                },
              );*/
            }),
    ]);
          /*},

        ),
      ],
    );*/
  }
}