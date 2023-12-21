class Settings {
  final bool firstSongDifferent;
  final int startingBarsNumber;
  final bool debuggingMode;

  Settings({
    this.firstSongDifferent = true,
    this.startingBarsNumber = 2,
    this.debuggingMode = false,
  });

  Settings copy({
    bool firstSongDifferent = true,
    int startingBarsNumber = 2,
    bool debuggingMode = false,
  }) =>
      Settings(
        firstSongDifferent: firstSongDifferent ?? this.firstSongDifferent,
        startingBarsNumber: startingBarsNumber ?? this.startingBarsNumber,
        debuggingMode: debuggingMode ?? this.debuggingMode,
      );
}