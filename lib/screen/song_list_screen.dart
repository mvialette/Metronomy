import 'dart:async';

import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/screen/music_player_screen.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:Metronomy/widgets/song_item.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SongListScreen extends StatelessWidget {

  const SongListScreen({
    super.key,
    required this.onSelectScreen
  });

  final void Function(String identifier) onSelectScreen;

  Future<List<Song>> getAllAvailableSongs() async {

    CollectionReference songs = FirebaseFirestore.instance.collection(kSelectedCollection);

    List<Song> allAvailableSongs = <Song>[];
    await songs.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        allAvailableSongs.add(Song.fromMap(doc.data() as Map<String, dynamic>));
      });

    }).catchError((error) => print("Failed to fetch users: $error"));
    return allAvailableSongs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Song>>(
        future: getAllAvailableSongs(),
        builder: (
            BuildContext context,
            AsyncSnapshot<List<Song>> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {

              return Column(
                children: [
                  Text(AppLocalizations.of(context)!.listDescriptionAllSongs,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (ctx, index) =>
                      SongItem(
                        song: snapshot.data![index],
                        onSelectSong: (song) {
                          RhythmProvider.of(context).updateSong(song, index);
                          onSelectScreen('summary');
                        },
                      ),
                  ),
                ],
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
