
class MusicStructure {

  late String sectionName, sectionShortcut;
  late int maximumBarsSection, maximumBeatSection;

  MusicStructure(String _sectionName, String _sectionShorcut, int _maximumBarsSection, int _maximumBeatSection){
    this.sectionName = _sectionName;
    this.sectionShortcut = _sectionShorcut;
    this.maximumBarsSection = _maximumBarsSection;
    this.maximumBeatSection = _maximumBeatSection;
  }
}