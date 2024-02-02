import 'dart:async';

import 'package:Metronomy/widgets/bullets_countdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:Metronomy/widgets/bullets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {

  const MusicPlayerScreen({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {
  late bool firstSongDifferent;
  late int startingBarsNumber;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    super.initState();
  }

  void _printSong(Song currentSong) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    print(encoder.convert(currentSong));
  }

  Column getCountdownWidgets(){

    final spinkit = SpinKitWave(
      color: Colors.orange,
      size: 200.0,
    );

    return Column(
      children: [
        Visibility(
          visible: ref.read(allSettingsProvider).debuggingMode,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.startingCountdown,
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
        Container(
          height: 50,
          //child: BulletsCountdown(ref.read(allSettingsProvider).startingBarsNumber),
          child: BulletsCountdown(startingBarsNumber: ref.read(allSettingsProvider).startingBarsNumber,),
        ),
      ],
    );
  }

  Column getPlayWidgets(){
    return Column(
      children: [
        Visibility(
          visible: ref.read(allSettingsProvider).debuggingMode,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.debugHitCount,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '${RhythmStore.of(context).debugTickCount}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.orange),
              ),
            ],
          ),
        ),
        Visibility(
          visible: ref.read(allSettingsProvider).advanceMode,
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            Text(
              AppLocalizations.of(context)!.breadcrumb,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Container(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: RhythmProvider.of(context)
                    .selectedSong
                    .musiquePart
                    .length,
                itemBuilder: (BuildContext context, int index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: CircleAvatar(
                    backgroundColor:
                    RhythmStore.of(context).sectionCurrentIndex == index
                        ? Colors.orange
                        : Colors.grey,
                    child: Text(RhythmProvider.of(context)
                        .selectedSong
                        .musiquePart[index]
                        .sectionShortcut),
                  ),
                ),
              ),
            ),
          ],)
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.songSection,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].sectionName}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.beatsByBar,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${RhythmProvider.of(context).selectedSong.beatsByBar}',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.timeSignature,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${RhythmStore.of(context).barsCurrentCounter} / ${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].maximumBarsSection}',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
          ],
        ),
        Container(
          height: 50,
          child: Bullets(),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.nextSection,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${RhythmProvider.of(context).selectedSong.nextSectionName(RhythmStore.of(context).sectionCurrentIndex)}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SoundToggleButton soundToggleButton = SoundToggleButton(
      setStateCallback: () {
        setState(() {});
      },
    );

    return Column(
      children: [

        Row(
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
        RhythmProvider.of(context).startingCountdown > 0 ? getCountdownWidgets() : getPlayWidgets(),
        SizedBox(
          height: 30,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  RhythmProvider.of(context).updateStopTimer();
                  widget.onSelectScreen('summary');
                });
              },
              tooltip: 'Return',
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 8.0),
            soundToggleButton,
            const SizedBox(width: 8.0),
            StopButton(
              setStateCallback: () {
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }
}
