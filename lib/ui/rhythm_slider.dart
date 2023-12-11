// lib/ui/rhythm_slider.dart

import 'package:flutter/material.dart';
import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';

class RhythmSlider extends StatelessWidget {

  const RhythmSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: kMinRhythm.toDouble(),
      max: kMaxRhythm.toDouble(),
      // utiliser RhythmStore pour RÉCUPÉRER la valeur du rythme
      value: RhythmProvider.of(context).rhythm.toDouble(),
      onChanged: (double value) =>
      // utiliser RhythmProvider pour MODIFIER la valeur du rythme
      RhythmProvider.of(context).updateRhythm(value.toInt()),
    );
  }
}