import 'package:flutter/material.dart';


// FIXME : RAJOUTER LE BLOCAGE DU MODE VEILLE DE L'ECRAN
class Settings {
  final bool firstSongDifferent;
  final int startingBarsNumber;
  final bool debuggingMode;
  final bool advanceMode;
  final bool darkMode;

  Settings({
    this.firstSongDifferent = true,
    this.startingBarsNumber = 2,
    this.debuggingMode = false,
    this.advanceMode = false,
    this.darkMode = false,
  });

  Settings copy({
    bool firstSongDifferent = true,
    int startingBarsNumber = 2,
    bool debuggingMode = false,
    bool advanceMode = false,
    bool darkMode = true,
  }) =>
      Settings(
        firstSongDifferent: firstSongDifferent ?? this.firstSongDifferent,
        startingBarsNumber: startingBarsNumber ?? this.startingBarsNumber,
        debuggingMode: debuggingMode ?? this.debuggingMode,
        advanceMode: advanceMode ?? this.advanceMode,
        darkMode: darkMode ?? this.darkMode,
      );
}