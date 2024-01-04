import 'dart:async';

import 'package:Metronomy/l10n/l10n.dart';
import 'package:Metronomy/main.dart';
import 'package:Metronomy/widgets/language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

import 'package:i18n_extension/i18n_widget.dart';

class UserProfilScreen extends ConsumerStatefulWidget {
  const UserProfilScreen({
    super.key,
  });

  @override
  ConsumerState<UserProfilScreen> createState() => _UserProfilScreenState();
}

//enum UserLocalEnum { french, us }

class _UserProfilScreenState extends ConsumerState<UserProfilScreen> {

  final FlutterLocalization localization = FlutterLocalization.instance;

  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;
  late String languageCode;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    debuggingMode = ref.read(allSettingsProvider).debuggingMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final locale = Localizations.localeOf(context);

    languageCode = locale.languageCode;

    final flag = L10n.getFlag(locale.languageCode);

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                const Text('User email : '),
                const Text('prenom.nom@email.com'),
              ],
            ),
            Row(
              children: [
                const Text('Language'),
              ],
            ),Row(
              children: [
                //Text("fr"),
                Text(
                  L10n.getFlag('fr'),
                  style: TextStyle(fontSize: 30),
                ),
                Text(AppLocalizations.of(context)!.localFr),
                Radio(
                  value: L10n.all[1].languageCode,
                  groupValue: languageCode,
                  onChanged: (String? value) {
                    setState(() {
                      languageCode = value!;
                      MetronomyApp.setLocale(context, Locale(languageCode));
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  L10n.getFlag('en'),
                  style: TextStyle(fontSize: 30),
                ),
                Text(AppLocalizations.of(context)!.localEn),
                //Text("en"),
                Radio(
                  value: L10n.all[0].languageCode,
                  groupValue: languageCode,
                  onChanged: (String? value) {
                    setState(() {

                      languageCode = value!;
                      MetronomyApp.setLocale(context, Locale(languageCode));
                    });

                  },
                )
              ],
            ),
            // Row(
            //   children: [
            //     Container(
            //       child:ListView.builder(
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         padding: const EdgeInsets.all(8),
            //         itemCount: L10n.all.length,
            //         itemBuilder: (context, index) {
            //           //return Text(L10n.all[index].languageCode);
            //           return Container(
            //             height: 50,
            //             child: Center(child: Text(L10n.all[index].languageCode),),
            //           );
            //         },
            //       )
            //     )
            //   ],
            // ),
          ]),
        ),
      ],
    );
  }
}
