class Settings {
  final bool firstSongDifferent;
  final int startingBarsNumber;

  Settings({
    this.firstSongDifferent = true,
    this.startingBarsNumber = 2,
  });

  Settings copy({
    bool firstSongDifferent = true,
    int startingBarsNumber = 2,
  }) =>
      Settings(
        firstSongDifferent: firstSongDifferent ?? this.firstSongDifferent,
        startingBarsNumber: startingBarsNumber ?? this.startingBarsNumber,
      );
}