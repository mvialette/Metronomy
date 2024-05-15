import 'package:flutter/material.dart';
import 'package:metronomy/store/rhythm_provider.dart';
import 'package:metronomy/store/rhythm_store.dart';

class BulletsCountdown extends StatefulWidget {
  final int startingBarsNumber;

  const BulletsCountdown({super.key, required this.startingBarsNumber});

  @override
  State<BulletsCountdown> createState() => _BulletsCountdownState();
}

class _BulletsCountdownState extends State<BulletsCountdown> {
  late int initialItemsCountdown;
  late int initialStartingCountdown;
  late int currentIndexBullent;

  @override
  void initState() {
    initialItemsCountdown = (RhythmProvider.of(context).startingCountdown) ~/
        widget.startingBarsNumber;
    initialStartingCountdown = RhythmProvider.of(context).startingCountdown;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (RhythmStore.of(context).enable) {
      currentIndexBullent = ((RhythmProvider.of(context).startingCountdown) -
              initialStartingCountdown) *
          -1;
      if (currentIndexBullent > initialItemsCountdown) {
        currentIndexBullent = ((RhythmProvider.of(context).startingCountdown) -
                initialItemsCountdown) *
            -1;
      } else {
        currentIndexBullent--;
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: initialItemsCountdown,
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
    if (!RhythmStore.of(context).enable) {
      return false;
    } else {
      return indexStartingAtZero == currentIndexBullent;
    }
  }
}
