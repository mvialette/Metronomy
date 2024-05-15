import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronomy/model/settings.dart';

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

  void updateAdvancedMode(bool advancedMode) {
    final newState = state.copy(advanceMode: advancedMode);
    state = newState;
  }

  void updateSettings(
      bool firstSongDifferent, bool debuggingMode, bool advancedMode) {
    final newState = state.copy(
        firstSongDifferent: firstSongDifferent,
        debuggingMode: debuggingMode,
        advanceMode: advancedMode);
    state = newState;
  }
}

final allSettingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
    (ref) => SettingsNotifier());
