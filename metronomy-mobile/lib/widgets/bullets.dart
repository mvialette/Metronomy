import 'package:flutter/material.dart';
import 'package:metronomy/store/rhythm_provider.dart';
import 'package:metronomy/store/rhythm_store.dart';

class Bullets extends StatelessWidget {
  const Bullets({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: RhythmProvider.of(context).selectedSong.beatsByBar,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            isCurrentTick(index, context)
                ? Icons.radio_button_on_rounded
                : Icons.radio_button_off_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        );
      },
    );
  }

  bool isCurrentTick(int indexStartingAtZero, BuildContext context) {
    var indexStartingAtOne = indexStartingAtZero + 1;
    var debugTickCountStartingAtZero = RhythmStore.of(context).debugTickCount;
    var currentTickStartingAtOne = debugTickCountStartingAtZero + 1;
    var moduloResult = currentTickStartingAtOne %
        RhythmProvider.of(context).selectedSong.beatsByBar;
    return moduloResult == 0
        ? (indexStartingAtZero ==
            RhythmProvider.of(context).selectedSong.beatsByBar - 1)
        : indexStartingAtOne == moduloResult;
  }
}
