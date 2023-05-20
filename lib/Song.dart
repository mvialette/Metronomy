
import 'package:Metronomy/MusicStructure.dart';

class Song {

  late String title;
  late int tempo;
  late List musiquePart;


  Song(String _title, int _tempo, List _musiquePart){
    this.title = _title;
    this.tempo = _tempo;
    this.musiquePart = _musiquePart;
  }
}