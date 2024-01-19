import 'package:Metronomy/l10n/l10n.dart';
import 'package:flutter/material.dart';

class Language extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Center(
      child: Text(
        flag,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

