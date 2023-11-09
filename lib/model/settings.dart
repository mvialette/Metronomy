class Settings {
  final bool firstSongDifferent;

  Settings({
    this.firstSongDifferent = true,
  });

  Settings copy({
    bool firstSongDifferent = true,
  }) =>
      Settings(
        firstSongDifferent: firstSongDifferent ?? this.firstSongDifferent,
      );
}