import 'package:flutter/material.dart';
import 'package:metronomy/model/constants.dart';
import 'package:metronomy/store/rhythm_provider.dart';

class RhythmSlider extends StatelessWidget {
  const RhythmSlider({super.key, required this.setStateCallback});

  final Function setStateCallback;

  @override
  Widget build(BuildContext context) {
    return Slider(
        min: kMinRhythm.toDouble(),
        max: kMaxRhythm.toDouble(),
        // utiliser RhythmStore pour RÉCUPÉRER la valeur du rythme
        value: RhythmProvider.of(context).rhythm.toDouble(),
        onChanged: (double value) {
          //RhythmProvider.of(context).rhythm = value.toInt();
          RhythmProvider.of(context).updateRhythm(value.toInt());
          //RhythmProvider.of(context).updateStopTimer();
          setStateCallback();
          //
          //setStateCallback();
        });
  }
}
