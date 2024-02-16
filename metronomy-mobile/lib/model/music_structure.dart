class MusicStructure {

  final String sectionName, sectionShortcut;
  final int maximumBarsSection, maximumBeatSection;

  const MusicStructure({
    required this.sectionName,
    required this.sectionShortcut,
    required this.maximumBarsSection,
    required this.maximumBeatSection
  });

  factory MusicStructure.fromMap(Map<String, dynamic> map) {

    return MusicStructure(
        sectionName: map['name'],
        sectionShortcut: map['shortcut'],
        maximumBarsSection: map['maximumBars'],
        maximumBeatSection: 0);
  }

  Map<String, dynamic> toJson() => {
    'name': sectionName,
    'shortcut': sectionShortcut,
    'maximumBars': maximumBarsSection,
    'beats': maximumBeatSection,
  };
}