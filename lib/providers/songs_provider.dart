import 'package:Metronomy/model/music_structure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Metronomy/model/song.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  SongsNotifier() : super(const []);

  CollectionReference loadSongs() {
    return FirebaseFirestore.instance.collection("songs");
  }

  List<Song> loadSongsToList() {

    FirebaseFirestore.instance.collection("songs").snapshots()
        .map((event) {
      List<Song> _songs = [];
      event.docs.forEach((element) {
        _songs.add(Song.fromMap(element.data()));
      });
      return _songs.reversed.toList();
    });
    return List.empty();
  }
}

final songsProvider = StateNotifierProvider<SongsNotifier, List<Song>>(
      (ref) => SongsNotifier(),
);
