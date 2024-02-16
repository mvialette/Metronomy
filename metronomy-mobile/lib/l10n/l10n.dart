import 'package:flutter/material.dart';

class L10n {

  static final all = [
    const Locale('en'), // do not change the order (index 0 have to be english)
    const Locale('fr'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'fr':
        return '🇫🇷';
      case 'us':
        return '🇺🇸';
      case 'en':
      default:
        return '🇬🇧';
    }
  }
}