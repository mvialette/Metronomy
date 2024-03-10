import 'dart:async';

import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/widgets/song_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    User? user = FirebaseAuth.instance.currentUser;
    final name = user != null ? user.displayName : "toto";
    final userEmail = user != null ? user.email : "toto";

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
                  SizedBox(height: 15,),
                  Text(
                    "Bienvenue " + userEmail.toString(),
                    //"Bienvenue " + name.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 15,),
                  Text(
                    AppLocalizations.of(context)!.listDescriptionAllSongs,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(height: 15,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (ctx, index) =>
                      Column(
                        children: [
                          SongItem(
                            song: snapshot.data![index],
                            onSelectSong: (song) {
                              RhythmProvider.of(context).updateSong(song, index);
                              onSelectScreen('summary');
                            },
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            indent: 20,
                            endIndent: 0,
                            color: Colors.grey,
                          ),
                        ],
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
