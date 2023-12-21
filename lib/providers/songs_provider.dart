import 'package:Metronomy/model/music_structure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Metronomy/model/song.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  SongsNotifier() : super(const []);
}

final songsProvider = StateNotifierProvider<SongsNotifier, List<Song>>(
      (ref) => SongsNotifier(),
);
