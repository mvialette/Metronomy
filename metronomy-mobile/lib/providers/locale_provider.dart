import 'dart:ui';

import 'package:Metronomy/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {


  LocaleNotifier() : super(Locale('fr'));

  void toggle(String languageCode) {
    state = Locale(languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
      (ref) => LocaleNotifier(),
);