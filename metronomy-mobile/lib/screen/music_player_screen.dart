import 'dart:convert';

import 'package:Metronomy/widgets/bullets_countdown.dart';
import 'package:flutter/foundation.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:Metronomy/widgets/bullets.dart';
import 'package:Metronomy/widgets/bullets_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
  const MusicPlayerScreen({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {

  late double bluetoothLatencyPercentage;

  @override
  void initState() {
    bluetoothLatencyPercentage = ref.read(allSettingsProvider).bluetoothLatencyPercentage;
    super.initState();
  }

  int _getBluetoothLatencyInMs() {
    double bluetoothLatencyPercentage = ref.read(allSettingsProvider).bluetoothLatencyPercentage;

    int rhythm = RhythmProvider.of(context).rhythm;
    // 60 secondes == 1 minutes
    // 1000 ms == 1 seconde
    int millisecondeParMinute = 60 * 1000;
    double songTimerInMillisecondes = millisecondeParMinute / rhythm;
    int currentLatencyToApply = (songTimerInMillisecondes * bluetoothLatencyPercentage - songTimerInMillisecondes).toInt();
    if(currentLatencyToApply < 0){
      currentLatencyToApply = 0;
    }

    return currentLatencyToApply;
  }

  // ignore: unused_element
  void _printSong(Song currentSong) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    if (kDebugMode) {
      print(encoder.convert(currentSong));
    }
  }

  Column getPlayWidgets() {
    return Column(children: [
      Visibility(
        visible: ref.read(allSettingsProvider).debuggingMode,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${RhythmStore.of(context).debugTickCount}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(AppLocalizations.of(context)!.debugHitCount,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary))
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
      Visibility(
          visible: ref.read(allSettingsProvider).advanceMode,
          child: Column(children: [
            const SizedBox(height: 30),
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
                                RhythmStore.of(context).sectionCurrentIndex ==
                                        index
                                    ? Colors.orange
                                    : Colors.grey,
                            child: Text(RhythmProvider.of(context)
                                .selectedSong
                                .musiquePart[index]
                                .sectionShortcut)))))
          ])),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
            '${RhythmStore.of(context).barsCurrentCounter} / ${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].maximumBarsSection}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.beatsByBar,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      SizedBox(
        height: 30,
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
              RhythmProvider.of(context)
                  .selectedSong
                  .musiquePart[RhythmStore.of(context).sectionCurrentIndex + 1].sectionName,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ))
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(AppLocalizations.of(context)!.nextSection,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.primary))
      ])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SoundToggleButton soundToggleButton = SoundToggleButton(
        setStateCallback: () {
          if (RhythmStore.of(context).enable) {
            new Future.delayed(Duration(milliseconds: _getBluetoothLatencyInMs()));
            setState(() {});
          }
        });

    return Column(children: [
      Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary),
              tooltip: 'Select this song en go to play mode',
              onPressed: () {
                widget.onSelectScreen('all-songs');
              }),
          Expanded(child: Container())
        ],
      ),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    RhythmProvider.of(context).selectedSong.title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        RhythmProvider.of(context).rhythm.toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.tempo,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${RhythmProvider.of(context).selectedSong.musiquePart[RhythmStore.of(context).sectionCurrentIndex].sectionName}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.songSection,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: RhythmProvider.of(context).currectStartingIndexCountdown <= RhythmProvider.of(context).startingCountdown,
          child: Column(children: [
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("${RhythmProvider.of(context).currectStartingIndexCountdown} / ${RhythmProvider.of(context).startingCountdown}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(AppLocalizations.of(context)!.countdown,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary))
            ]),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text((bluetoothLatencyPercentage * 100).toStringAsPrecision(4) + " %",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary)),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(AppLocalizations.of(context)!.latency,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.primary))
            ]),
            const SizedBox(height: 20),
            Column(children: [
              SizedBox(
                  height: 50,
                  child: BulletsCountdown(
                      startingBarsNumber:
                          ref.read(allSettingsProvider).startingBarsNumber))
            ])
          ])),
      Visibility(
        visible: RhythmProvider.of(context).currectStartingIndexCountdown > RhythmProvider.of(context).startingCountdown,
        child: getPlayWidgets(),
      ),
      //const SizedBox(height: 30),
      // RhythmProvider.of(context).startingCountdown > 0
      //     ? const Text("")
      //     : getPlayWidgets(),
      Expanded(child: Container()),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        soundToggleButton,
        const SizedBox(width: 8.0),
        StopButton(setStateCallback: () {
          setState(() {});
        })
      ])
    ]);
  }
}
