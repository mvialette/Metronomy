import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:metronomy/model/constants.dart';
import 'package:metronomy/model/song.dart';
import 'package:metronomy/store/rhythm_provider.dart';
import 'package:metronomy/widgets/song_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getLocalFile(String collectionDatabaseName) async {
    final path = await _localPath;

    late String collectionDatabaseNameInLocal;
    Directory(path).listSync().forEach((fileIntoApplicationDocumentsDirectory) {
      String currentFileName =
          Directory(path).listSync()[2].path.split('/').last;
      if (currentFileName.startsWith("database-songs_20")) {
        collectionDatabaseNameInLocal = currentFileName;
      }
      //allAvailableSongsInLocal.add(Song.fromMap(songString));
    });

    // ignore: unnecessary_null_comparison
    return File('$path/database-$collectionDatabaseNameInLocal' == null
        ? '$collectionDatabaseName.json'
        : collectionDatabaseNameInLocal);
  }

  Future<File> writeDatabase(
      String collectionDatabaseName, List<Song> songs) async {
    final file = await getLocalFile(collectionDatabaseName);

    String songsInJsonString = jsonEncode(songs);

    // Write the file
    return file.writeAsString(songsInJsonString);
  }

  Future<List<Song>> readDatabase(String collectionDatabaseName) async {
    try {
      final file = await getLocalFile(collectionDatabaseName);

      // Read the file
      final contents = await file.readAsString();

      List<Song> allAvailableSongsInLocal = <Song>[];
      jsonDecode(contents).forEach((songString) {
        allAvailableSongsInLocal.add(Song.fromMap(songString));
      });

      return allAvailableSongsInLocal;
    } catch (e) {
      // If encountering an error, return 0
      return <Song>[];
    }
  }

  Future<List<Song>> getAllAvailableSongsFromFirestore(
      String collectionDatabaseName) async {
    CollectionReference songs =
        FirebaseFirestore.instance.collection(collectionDatabaseName);
    List<Song> allAvailableSongs = <Song>[];

    await songs.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        allAvailableSongs.add(Song.fromMap(doc.data() as Map<String, dynamic>));
      }
      // ignore: invalid_return_type_for_catch_error, avoid_print
    }).catchError((error) => print("Failed to fetch users: $error"));

    // save into a local file
    writeDatabase(collectionDatabaseName, allAvailableSongs);

    return allAvailableSongs;
  }

  Future<List<Song>> getAllAvailableSongsFromLocalFile(
      String collectionDatabaseName) async {
    List<Song> allAvailableSongs = await readDatabase(collectionDatabaseName);
    return allAvailableSongs;
  }

  Future<List<Song>> getAllAvailableSongs() async {
    CollectionReference settings =
        FirebaseFirestore.instance.collection(kFirebaseSettings);
    late String collectionDatabaseName;

    // ignore: unused_local_variable
    List<List<String>> allFirebaseSettings = <List<String>>[];
    await settings.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        collectionDatabaseName = (doc.data()! as Map)["name"];
      }
    }).catchError((error) =>
        // ignore: invalid_return_type_for_catch_error, avoid_print
        print("Failed to fetch database settings from Firebase: $error"));

    //List<Song> allAvailableSongs = await getAllAvailableSongsFromLocalFile(collectionDatabaseName);
    List<Song> allAvailableSongs =
        await getAllAvailableSongsFromFirestore(collectionDatabaseName);

    return allAvailableSongs;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    final name = user != null ? user.displayName : "toto";
    // ignore: unused_local_variable
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
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return Column(children: [
                    const SizedBox(height: 15),
                    Text(AppLocalizations.of(context)!.listDescriptionAllSongs,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 15),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (ctx, index) => Column(children: [
                              SongItem(
                                  song: snapshot.data![index],
                                  onSelectSong: (song) {
                                    RhythmProvider.of(context)
                                        .updateSong(song, index);
                                    onSelectScreen('summary');
                                  }),
                              const Divider(
                                height: 20,
                                thickness: 1,
                                indent: 20,
                                endIndent: 0,
                                color: Colors.grey,
                              )
                            ]))
                  ]);
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }));
  }
}
