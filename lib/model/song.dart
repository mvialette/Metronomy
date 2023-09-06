import 'package:Metronomy/model/music_structure.dart';

class Song {

  final String title;
  final int tempo;
  final List<MusicStructure> musiquePart;

  const Song({
    required this.title,
    required this.tempo,
    required this.musiquePart
  });
}