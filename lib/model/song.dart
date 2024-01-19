import 'package:Metronomy/model/music_structure.dart';

class Song {

  final String title;
  final int tempo;
  final int beatsByBar;
  final int beatsDuring;
  final List<MusicStructure> musiquePart;

  const Song({
    required this.title,
    required this.tempo,
    required this.beatsByBar,
    required this.beatsDuring,
    required this.musiquePart
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
        beatsByBar: int.parse(signatureSplit[0]),
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

  String getSignature(){
    // '2/4', '3/4', '4/4', '7/8', '12/8'
    return beatsByBar.toString() + "/" + beatsDuring.toString();
  }
}