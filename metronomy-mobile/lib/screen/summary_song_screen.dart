import 'package:metronomy/store/rhythm_provider.dart';
import 'package:metronomy/ui/rhythm_slider.dart';
import 'package:metronomy/widgets/lists_with_cards.dart';
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
    return Column(children: <Widget>[
      Row(children: [
        IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary),
            tooltip: 'Select this song en go to play mode',
            onPressed: () {
              widget.onSelectScreen('all-songs');
            })
      ]),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              RhythmProvider.of(context).selectedSong.title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 10),
            Text('Author',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ))
          ])),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context).selectedSong.signature,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
          Expanded(child: Container()),
          Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context).rhythm.toString(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
          Expanded(child: Container()),
          Text(
              // permet d'accéder à la valeur actualisée du rythme
              RhythmProvider.of(context)
                  .selectedSong
                  .musiquePart
                  .length
                  .toString(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
          Expanded(child: Container()),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Text(AppLocalizations.of(context)!.timeSignature,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )),
          Expanded(child: Container()),
          Text(AppLocalizations.of(context)!.tempo,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )),
          Expanded(child: Container()),
          Text(AppLocalizations.of(context)!.songSection,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )),
          Expanded(
            child: Container(),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: RhythmSlider(setStateCallback: () {
            setState(() {});
          })),
      const SizedBox(height: 10),
      const ListsWithCards(),
      Expanded(
        child: Container(),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () {
              widget.onSelectScreen('play-a-song');
            },
            child: Text(AppLocalizations.of(context)!.play))
      ]),
      const SizedBox(height: 20),
    ]);
  }
}
