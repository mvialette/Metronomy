// FIXME : RAJOUTER LE BLOCAGE DU MODE VEILLE DE L'ECRAN
class Settings {
  final bool firstSongDifferent;
  final int startingBarsNumber;
  final bool debuggingMode;
  final bool advanceMode;
  final bool darkMode;
  final double bluetoothLatencyPercentage;

  Settings(
      {this.firstSongDifferent = true,
      this.startingBarsNumber = 2,
      this.debuggingMode = false,
      this.advanceMode = false,
      this.darkMode = false,
      this.bluetoothLatencyPercentage = 1});

  Settings copy(
          {bool firstSongDifferent = true,
          int startingBarsNumber = 2,
          bool debuggingMode = false,
          bool advanceMode = false,
          bool darkMode = true,
          double bluetoothLatencyPercentage = 0}) =>
      Settings(
          firstSongDifferent: firstSongDifferent,
          startingBarsNumber: startingBarsNumber,
          debuggingMode: debuggingMode,
          advanceMode: advanceMode,
          darkMode: darkMode,
          bluetoothLatencyPercentage:bluetoothLatencyPercentage
      );
}
