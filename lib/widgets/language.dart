import 'package:Metronomy/l10n/l10n.dart';
import 'package:flutter/material.dart';
// import 'package:localization_arb_example/provider/locale_provider.dart';
// import 'package:provider/provider.dart';

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
      // Ou alors pour mettre dans un cercle :
      // CircleAvatar(
      //   backgroundColor: Colors.white,
      //   radius: 72,
      //   child: Text(
      //     flag,
      //     style: TextStyle(fontSize: 80),
      //   ),
      // ),
    );
  }
}

