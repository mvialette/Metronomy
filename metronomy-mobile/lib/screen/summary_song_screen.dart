import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/widgets/lists_with_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummarySongScreen extends ConsumerStatefulWidget {

  const SummarySongScreen({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  ConsumerState<SummarySongScreen> createState() => _SummarySongScreenState();
}

class _SummarySongScreenState extends ConsumerState<SummarySongScreen> {

  @override
  Widget build(BuildContext context) {
    TextScaler textScalerString = MediaQuery.of(context).textScaler;
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor.clamp(0.8, 0.9);

    return Column(
      children: <Widget>[
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Icon(
                Icons.music_note,
                //Icons.music_note,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),*/
              /*Text(
                "30 // " + MediaQuery.of(context).textScaler.clamp(minScaleFactor: 0.85,maxScaleFactor: 1.6).toString(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              */
              Text(
                RhythmProvider.of(context).selectedSong.title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              /*SizedBox(
                height: 2,
              ),
              Text(
                RhythmProvider.of(context).selectedSong.title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: MediaQuery.of(context).textScaler.scale(Theme.of(context).textTheme.bodyLarge!.fontSize!)!,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  RhythmProvider.of(context).selectedSong.title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              */
              SizedBox(
                height: 10,
              ),
              Text(
                'Author',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Column(
              children: [
                Text(
                  // permet d'accéder à la valeur actualisée du rythme
                  RhythmProvider.of(context).selectedSong.signature,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.timeSignature,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Column(
              children: [
                Text(
                  // permet d'accéder à la valeur actualisée du rythme
                  RhythmProvider.of(context).rhythm.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
            ),
            Expanded(
              child: Container(),
            ),
            Column(
              children: [
                Text(
                  // permet d'accéder à la valeur actualisée du rythme
                  RhythmProvider.of(context).selectedSong.musiquePart.length.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.songSection,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: RhythmSlider(
            setStateCallback: () {
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 10,),
        ListsWithCards(),
        Expanded(
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.onSelectScreen('play-a-song');
              },
              child: Text('Jouer'),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}