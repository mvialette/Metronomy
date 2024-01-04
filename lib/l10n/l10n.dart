import 'package:flutter/material.dart';

class L10n {

  static final all = [
    const Locale('en'),
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