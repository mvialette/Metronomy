import 'package:Metronomy/model/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings> {

  SettingsNotifier() : super(Settings());

  void updateFirstSongDifferent(bool firstSongDifferent) {
    final newState = state.copy(firstSongDifferent: firstSongDifferent);
    state = newState;
  }
}

final allSettingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) => SettingsNotifier());