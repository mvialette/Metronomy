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

  int _songIndex = 0;
  late CollectionReference songs;
  late bool firstSongDifferent;

  @override
  void initState() {
    songs = ref.read(songsProvider.notifier).loadSongs();
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;

    super.initState();
  }

  void _printSong(Song currentSong) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    print(encoder.convert(currentSong));
  }

  @override
  Widget build(BuildContext context) {

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
                      }
                    ),
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
          child:
          StreamBuilder(
              stream: songs!.snapshots(),
              builder:
                  (context, snapshot) {
                /*
                If this part is uncomment, refresing ui is blinking
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }*/

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No messages'),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong...'),
                  );
                }

                final loadedSong = snapshot.data!.docs;
                final selectedSong = loadedSong[_songIndex].data() as Map<String, dynamic>;
                Song song = Song.fromMap(selectedSong);
                //_printSong(song);
                RhythmProvider.of(context).updateSong(song, _songIndex);

                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Titre : ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(
                            height: 40,),
                          Text(
                              song.title,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.orange),
                            ),
                          ],
                      ),
                    ),
                    AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: (RhythmProvider.of(context).startingCountdown > 0)
                          ? 1.0
                          : 0.0,
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
                                    color: Colors.orange
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: RhythmProvider.of(context).startingCountdown == 0
                            ? 1.0
                            : 0.0,
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
                                      color: Colors.orange
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Partie : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                Text(
                                  '${song.musiquePart[RhythmStore.of(context).sectionCurrentIndex].sectionName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mesure : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                Text(
                                  '${RhythmStore.of(context).barsCurrentCounter} / ${song.musiquePart[RhythmStore.of(context).sectionCurrentIndex].maximumBarsSection}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Temps: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                Icon(
                                    RhythmStore.of(context).timeThree
                                        ? Icons.radio_button_on_rounded
                                        : Icons.radio_button_off_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                Icon(
                                    RhythmStore.of(context).timeFour
                                        ? Icons.radio_button_on_rounded
                                        : Icons.radio_button_off_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tempo : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
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
                  ],
                );
              })

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
            StopButton(
              setStateCallback: () {
                setState(() {});
              },
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )
    );
  }
}