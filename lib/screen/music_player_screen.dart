
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:Metronomy/widgets/bullets.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    super.initState();
  }

  void _printSong(Song currentSong) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    print(encoder.convert(currentSong));
  }

  @override
  Widget build(BuildContext context) {
    SoundToggleButton soundToggleButton = SoundToggleButton(
      setStateCallback: () {
        setState(() {});
      },
    );

    const spinkit = SpinKitWave(
      color: Colors.orange,
      size: 200.0,
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
            const SizedBox(
              height: 40,
            ),
            Text(
              RhythmProvider.of(context).selectedSong.title,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Colors.orange),
            ),
          ],
        ),
        AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity:
              (RhythmProvider.of(context).startingCountdown > 0) ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Column(
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
                      '${RhythmProvider.of(context).startingCountdown}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.orange),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: RhythmProvider.of(context).enableTimer,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    spinkit,
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity:
              RhythmProvider.of(context).startingCountdown == 0 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Column(
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
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.breadcrumb,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
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
              const SizedBox(
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
                    RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].sectionName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(
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
                    '${RhythmStore.of(context).barsCurrentCounter} / ${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].maximumBarsSection}',
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
                child: Bullets(),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.tempo,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const RhythmLabel(),
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
              child: const Icon(Icons.arrow_back),
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
