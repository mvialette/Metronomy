import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<bool> {

  LocaleNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, bool>(
      (ref) => LocaleNotifier(),
);