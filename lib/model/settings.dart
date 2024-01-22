import 'package:flutter/material.dart';

class Settings {
  final bool firstSongDifferent;
  final int startingBarsNumber;
  final bool debuggingMode;
  final bool advanceMode;

  Settings({
    this.firstSongDifferent = true,
    this.startingBarsNumber = 2,
    this.debuggingMode = false,
    this.advanceMode = false,
  });

  Settings copy({
    bool firstSongDifferent = true,
    int startingBarsNumber = 2,
    bool debuggingMode = false,
    bool advanceMode = false,
  }) =>
      Settings(
        firstSongDifferent: firstSongDifferent ?? this.firstSongDifferent,
        startingBarsNumber: startingBarsNumber ?? this.startingBarsNumber,
        debuggingMode: debuggingMode ?? this.debuggingMode,
        advanceMode: advanceMode ?? this.advanceMode,
      );
}