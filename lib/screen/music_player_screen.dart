import 'dart:async';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/providers/songs_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const millisecondsPerMinute = 60000;
const microsecondsPerMinute = 60000000;

class MusicPlayerScreen extends ConsumerStatefulWidget {

  const MusicPlayerScreen({super.key});

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {

  bool printDebug = false;

  int _songIndex = 0;
  //int _sectionCurrentIndex = 0;
  int _beatCounter = 0;
  //int _barsCurrentCounter = 0;

  int debugTempsDActionNmoinsUn = 0;
  int debugTempsAvgMin = 0;
  int debugTempsAvgMax = 0;

  double _bpm = 60;
  int _tickInterval = 0;

  Duration? bpmDuration;

  int valueCountdown = 0;
  int oldValuePrint = 0;
  int oldValueCount = 0;
  var allValue = [];
  //int _debugHitCount = 0;

  late Future<void> _songsFuture;
  var songsAvailable;

  /////////////
  var sampleSize = 25;

  static const _defaultBpm = 60;

  var bpm = _defaultBpm;
  //var intervalInMilliseconds = millisecondsPerMinute / _defaultBpm;

  @override
  void initState() {
    _songsFuture = ref.read(songsProvider.notifier).loadSongs();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    songsAvailable = ref.watch(songsProvider);
    final bool firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;

    //RhythmProvider.of(context).updateMusicSection(myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBeatSection, myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBarsSection);
    String titleFromFirestore = "empty";
    final docRef = FirebaseFirestore.instance.collection("songs").doc("here_comes_the_rain_again");
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        titleFromFirestore = data['title'];
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Text('Settings'),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Text('First song Different'),
                    Switch(
                        value: firstSongDifferent,
                        onChanged: (check) {
                          ref.read(allSettingsProvider.notifier).updateFirstSongDifferent(check);
                          Navigator.pop(context);
                        }),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(children: [
            Icon(Icons.music_note),
            SizedBox(width: 15),
            Text('Metronomy')
          ]),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child:
                  FutureBuilder(
                    future: _songsFuture,
                    builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting ?
                      const Center(
                        child: CircularProgressIndicator()
                      ) :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Firestore'),
                          Text(titleFromFirestore),
                          Text(
                            'Titre : ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '${songsAvailable[0].title}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.normal,
                                color: Colors.orange
                            ),
                          ),
                        ],
                      ),
                  )
              ),
              SizedBox(height: 15,),
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: RhythmStore.of(context).startingCountdown == 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                // The green box must be a child of the AnimatedOpacity widget.
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Partie : ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '${songsAvailable[_songIndex].musiquePart[RhythmStore.of(context).sectionCurrentIndex].sectionName}',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mesure : ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '${RhythmStore.of(context).barsCurrentCounter} / ${songsAvailable[_songIndex].musiquePart[RhythmStore.of(context).sectionCurrentIndex].maximumBarsSection}' ,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange
                          ),
                        ),
                      ],

                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Temps: ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          RhythmStore.of(context).timeOne?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary,
                          size: 30,
                        ),
                        Icon(RhythmStore.of(context).timeTwo?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                        Icon(RhythmStore.of(context).timeThree?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                        Icon(RhythmStore.of(context).timeFour?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tempo : ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        // ${songsAvailable[0].tempo}
                        RhythmLabel(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: RhythmSlider(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Starting countdown : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${RhythmStore.of(context).startingCountdown}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.orange
                    ),
                  ),
                ],
              ),
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
                        color: Colors.orange
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoundToggleButton(
              setStateCallback: () {
                setState(() {});
              },
            ),
            const SizedBox(width: 8.0),
            StopButton(),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )
    );
  }
}