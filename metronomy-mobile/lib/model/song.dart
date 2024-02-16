import 'package:Metronomy/model/music_structure.dart';

class Song {

  final String title;
  final int tempo;
  final int beatsByBar;
  final int beatsDuring;
  final String signature;
  final List<MusicStructure> musiquePart;

  const Song({
    required this.title,
    required this.tempo,
    required this.beatsByBar,
    required this.signature,
    required this.beatsDuring,
    required this.musiquePart,
  });

  String nextSectionName(int sectionCurrentIndex){
    if((sectionCurrentIndex + 1) == this.musiquePart.length){
      return ""; // We display nothing
    }
    return this.musiquePart[sectionCurrentIndex + 1].sectionName;
  }

  factory Song.fromMap(Map<String, dynamic> map) {

    List<MusicStructure> _sections = [];
    map['sections'].forEach((element) {
      _sections.add(MusicStructure.fromMap(element));
    });

    var signatureSplit = map['signature'].split('/');

    return Song(
        title: map['title'],
        tempo: map['tempo'],
        beatsByBar: map['beatsByBars'],
        signature: map['signature'],
        beatsDuring: int.parse(signatureSplit[1]),
        musiquePart: _sections ?? List.empty());
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'tempo': tempo,
    'beatsByBar': beatsByBar,
    'beatsDuring': beatsDuring,
    'sections': musiquePart,
  };
}