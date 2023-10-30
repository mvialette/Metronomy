import 'package:flutter/material.dart';
import 'package:Metronomy/store/rhythm_store.dart';

class RhythmLabel extends StatelessWidget {

  const RhythmLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      // permet d'accéder à la valeur actualisée du rythme
      RhythmStore.of(context).rhythm.toString(),
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: 80,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}