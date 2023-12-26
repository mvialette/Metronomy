import 'dart:async';

import 'package:Metronomy/main.i18n.dart';
import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/providers/songs_provider.dart';
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

enum UserLocalEnum { french, us }

class _UserProfilScreenState extends ConsumerState<UserProfilScreen> {

  final FlutterLocalization localization = FlutterLocalization.instance;

  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;

  UserLocalEnum? _actualUserLocal = UserLocalEnum.french;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    debuggingMode = ref.read(allSettingsProvider).debuggingMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                const Text('User email : '),
              ],
            ),
            Row(
              children: [
                const Text('Language'),
              ],
            ),Row(
              children: [
                Text(localFrenchText.i18n),
                Radio(
                  value: UserLocalEnum.french,
                  groupValue: _actualUserLocal,
                  onChanged: (UserLocalEnum? selectedValue) {
                    setState(() {
                      _actualUserLocal = UserLocalEnum.french;
                      print(selectedValue);
                      I18n.of(context).locale = Locale("fr", "FR");
                      /*_actualUserLocal = selectedValue;
                      localization.translate('fr');*/
                    });
                  },
                ),
              ],
            ),Row(
              children: [
                Text(localEnglishText.i18n),
                Radio(
                  value: UserLocalEnum.us,
                  groupValue: _actualUserLocal,
                  onChanged: (UserLocalEnum? selectedValue) {
                    setState(() {
                      _actualUserLocal = UserLocalEnum.us;
                      print(selectedValue);
                      I18n.of(context).locale = Locale("en", "US");
                      //_actualUserLocal = selectedValue;
                      //localization.translate('en');
                    });
                  },
                ),
              ],
            ),

          ]),
        ),
      ],
    );
  }
}
