import 'dart:async';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/providers/songs_provider.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class MusicPlayerScreen extends ConsumerStatefulWidget {

  const MusicPlayerScreen({super.key});

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {

  late bool firstSongDifferent;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    super.initState();
  }

  void _printSong(Song currentSong) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    print(encoder.convert(currentSong));
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Titre : ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                RhythmProvider.of(context).selectedSong.title,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Colors.orange),
              ),
            ],
          ),
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity:
            (RhythmProvider.of(context).startingCountdown > 0) ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Starting countdown : ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '${RhythmProvider.of(context).startingCountdown}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
              opacity:
              RhythmProvider
                  .of(context)
                  .startingCountdown == 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Debug hit count : ',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '${RhythmStore.of(context).debugTickCount}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Partie : ',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].sectionName}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Timeline : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    height: 50,
                    child:
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: RhythmProvider.of(context).selectedSong.musiquePart.length,
                      itemBuilder: (BuildContext context, int index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          backgroundColor: RhythmStore.of(context).sectionCurrentIndex == index ? Colors.orange : Colors.grey,
                          child: Text(RhythmProvider.of(context).selectedSong.musiquePart[index].sectionShortcut),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mesure : ',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '${RhythmStore.of(context).barsCurrentCounter} / ${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].maximumBarsSection}',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        RhythmStore.of(context).timeOne
                            ? Icons.radio_button_on_rounded
                            : Icons.radio_button_off_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      Icon(
                          RhythmStore.of(context).timeTwo
                              ? Icons.radio_button_on_rounded
                              : Icons.radio_button_off_rounded,
                          color: Theme.of(context).colorScheme.primary),
                      Icon(
                          RhythmStore.of(context).timeThree
                              ? Icons.radio_button_on_rounded
                              : Icons.radio_button_off_rounded,
                          color: Theme.of(context).colorScheme.primary),
                      RhythmProvider.of(context).selectedSong.beatsByBar > 3 ? (
                          Icon(
                              RhythmStore.of(context).timeFour
                                  ? Icons.radio_button_on_rounded
                                  : Icons.radio_button_off_rounded,
                              color: Theme.of(context).colorScheme.primary)):Text(""),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
          ),

          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tempo : ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              RhythmLabel(),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: RhythmSlider(
              setStateCallback: () {
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SoundToggleButton(
                setStateCallback: () {
                  setState(() {});
                },
              ),
              const SizedBox(width: 8.0),
              StopButton(
                setStateCallback: () {
                  setState(() {});
                },
              ),
              // This trailing comma makes auto-formatting nicer for build methods.
            ],
          )
        ],
      );
  }
}