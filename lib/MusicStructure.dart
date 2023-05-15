
class MusicStructure {

  late String sectionName, sectionShortcut;
  late int barsRemaining, maximumBeatMesure;

  MusicStructure(String _sectionName, String _sectionShorcut, int _barsRemainingCounter, int _beatCounter){
    this.sectionName = _sectionName;
    this.sectionShortcut = _sectionShorcut;
    this.barsRemaining = _barsRemainingCounter;
    this.maximumBeatMesure = _beatCounter;
  }
}