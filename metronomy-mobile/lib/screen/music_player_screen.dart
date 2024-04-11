import 'dart:convert';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/screen/home_screen.dart';
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

  Column getPlayWidgets(){
    return Column(children: [
      Visibility(
        visible: ref.read(allSettingsProvider).debuggingMode,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${RhythmStore.of(context).debugTickCount}',
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
                  AppLocalizations.of(context)!.debugHitCount,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
      Visibility(
        visible: ref.read(allSettingsProvider).advanceMode,
        child: Column(
          children: [
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
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            RhythmProvider.of(context).rhythm.toString(),
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
            AppLocalizations.of(context)!.tempo,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // try{
    //   _printSong(RhythmProvider.of(context).selectedSong);
    // }catch(LateInitializationError){
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomeScreen()),
    //   );
    // }

    SoundToggleButton soundToggleButton = SoundToggleButton(
      setStateCallback: () {
        setState(() {});
      },
    );

    return Column(
      children: [
        Row(children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Select this song en go to play mode',
            onPressed: () {
              widget.onSelectScreen('all-songs');
            },
          ),
          Expanded(
            child: Container(),
          ),
        ],),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                RhythmProvider.of(context).selectedSong.title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
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
          visible: RhythmProvider.of(context).startingCountdown > 0,
          child: Column(
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${RhythmProvider.of(context).startingCountdown - 1}',
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
                    AppLocalizations.of(context)!.countdown,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Column(children: [
                Container(
                  height: 50,
                  //child: BulletsCountdown(ref.read(allSettingsProvider).startingBarsNumber),
                  child: BulletsCountdown(startingBarsNumber: ref.read(allSettingsProvider).startingBarsNumber,),
                ),
              ],)
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        RhythmProvider.of(context).startingCountdown > 0 ? Text("") : getPlayWidgets(),
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
