import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:Metronomy/widgets/lists_with_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SummarySongScreen extends ConsumerStatefulWidget {

  const SummarySongScreen({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  ConsumerState<SummarySongScreen> createState() => _SummarySongScreenState();
}

class _SummarySongScreenState extends ConsumerState<SummarySongScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.songTitleLabel,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                RhythmProvider.of(context).selectedSong.title,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Colors.orange),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.timeSignature,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context).selectedSong.getSignature(),
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.normal,
                  color: Colors.orange),
            ),
          ],
        ),
        Visibility(
          visible: (ref.read(allSettingsProvider).debuggingMode),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Starting countdown : ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '${RhythmProvider.of(context).startingCountdown - 1}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.orange),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.tempo,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            RhythmLabel(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: RhythmSlider(
            setStateCallback: () {
              setState(() {});
            },
          ),
        ),
        new Expanded(
          child:
            ListsWithCards(),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.orange),
              tooltip: 'Select this song en go to play mode',
              onPressed: () {
                widget.onSelectScreen('all-songs');
                //onSelectScreen('summary');
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_circle, color: Colors.orange),
              tooltip: 'Select this song en go to play mode',
              onPressed: () {
                widget.onSelectScreen('play-a-song');
                //onSelectScreen('summary');
              },
            ),
          ],
        ),
      ],
    );
  }
}