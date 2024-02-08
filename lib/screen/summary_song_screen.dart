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
              Icon(
                Icons.music_note,
                //Icons.music_note,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                RhythmProvider.of(context).selectedSong.title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
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
        SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context).selectedSong.signature,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context).rhythm.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context).selectedSong.musiquePart.length.toString(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Text(
              AppLocalizations.of(context)!.timeSignature,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              AppLocalizations.of(context)!.tempo,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              AppLocalizations.of(context)!.songSection,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: RhythmSlider(
            setStateCallback: () {
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 40,),
        Visibility(
          visible: (ref.read(allSettingsProvider).debuggingMode),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // FIXME afficher le chiffre du compte à rebours
                  Text(
                    'Starting countdown : ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${RhythmProvider.of(context).startingCountdown - 1}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
            ],
          ),
        ),
        /*Row(
          children: [
            Expanded(
              child: Container(),
            ),
            Column(children: [
              Text('AAA',),
              Text('A',),
              Text('AA',),
            ]),
            Expanded(
              child: Container(),
            ),
            Column(children: [
              Text('AB',),
              Text('ABBBBB',),
              Text('A',),
            ]),
            Expanded(
              child: Container(),
            ),
          ],
        ),*/
        /*Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Column(children: [
                    Text(
                      'AAA',
                    ),
                  ]),
                  Expanded(
                    child: Container(),
                  ),
                  Column(children: [
                    Text(
                      'AB',
                    ),
                  ]),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),*/
        new Expanded(
          child:
            ListsWithCards(),
        ),
        /*
        Expanded(
          child: Container(),
        ),*/
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(300, 50),
              ),
              onPressed: () {
                widget.onSelectScreen('play-a-song');
              },
              child: Text('Jouer'),
            ),
          ],
        ),
      ],
    );
  }
}