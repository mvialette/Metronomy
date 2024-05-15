import 'package:flutter/material.dart';
import 'package:metronomy/l10n/l10n.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Center(child: Text(flag, style: const TextStyle(fontSize: 30)));
  }
}
