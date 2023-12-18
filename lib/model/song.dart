import 'package:Metronomy/model/music_structure.dart';

class Song {

  final String title;
  final int tempo;
  final int beatsByBar;
  final List<MusicStructure> musiquePart;

  const Song({
    required this.title,
    required this.tempo,
    required this.beatsByBar,
    required this.musiquePart
  });

  factory Song.fromMap(Map<String, dynamic> map) {

    List<MusicStructure> _sections = [];
    map['sections'].forEach((element) {
      _sections.add(MusicStructure.fromMap(element));
    });

    return Song(
        title: map['title'],
        tempo: map['tempo'],
        beatsByBar: map['beatsByBars'],
        musiquePart: _sections ?? List.empty());
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'tempo': tempo,
    'beatsByBar': beatsByBar,
    'sections': musiquePart,
  };
}