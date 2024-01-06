import 'dart:async';

import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;

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
                Text(AppLocalizations.of(context)!.firstSongDifferent),
                Switch(
                    value: firstSongDifferent,
                    onChanged: (check) {
                      setState(() {
                        firstSongDifferent = check;
                      });
                      ref
                          .read(allSettingsProvider.notifier)
                          .updateFirstSongDifferent(firstSongDifferent);
                    }),
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.debugMode),
                Switch(
                    value: debuggingMode,
                    onChanged: (check) {
                      setState(() {
                        debuggingMode = check;
                      });
                      ref
                          .read(allSettingsProvider.notifier)
                          .updateDebuggingMode(firstSongDifferent);
                    }),
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.startingCountdownBarsNumber),
                SizedBox(width: 10,),
                Text('${startingBarsNumber}',
                  //style: Theme.of(context).textTheme.headlineMedium,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.databaseVersion),
                SizedBox(width: 10,),
                Text('${kSelectedCollection}',
                  //style: Theme.of(context).textTheme.headlineMedium,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20
                  ),
                )
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
