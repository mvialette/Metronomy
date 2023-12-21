import 'dart:async';

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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class UserProfilScreen extends ConsumerStatefulWidget {
  const UserProfilScreen({
    super.key,
  });

  @override
  ConsumerState<UserProfilScreen> createState() => _UserProfilScreenState();
}

enum UserLocalEnum { french, us }

class _UserProfilScreenState extends ConsumerState<UserProfilScreen> {
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
                const Text('French'),
                Radio(
                  value: UserLocalEnum.french,
                  groupValue: _actualUserLocal,
                  onChanged: (UserLocalEnum? selectedValue) {
                    setState(() {
                      _actualUserLocal = selectedValue;
                    });
                  },
                ),
              ],
            ),Row(
              children: [
                const Text('Anglais'),
                Radio(
                  value: UserLocalEnum.us,
                  groupValue: _actualUserLocal,
                  onChanged: (UserLocalEnum? selectedValue) {
                    setState(() {
                      _actualUserLocal = selectedValue;
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
