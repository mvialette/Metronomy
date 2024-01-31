import 'package:Metronomy/model/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings> {

  SettingsNotifier() : super(Settings());

  void updateFirstSongDifferent(bool firstSongDifferent) {
    final newState = state.copy(firstSongDifferent: firstSongDifferent);
    state = newState;
  }

  void updateStartingBarsNumber(int startingBarsNumber) {
    final newState = state.copy(startingBarsNumber: startingBarsNumber);
    state = newState;
  }

  void updateDebuggingMode(bool debuggingMode) {
    final newState = state.copy(debuggingMode: debuggingMode);
    state = newState;
  }
}

final allSettingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) => SettingsNotifier());