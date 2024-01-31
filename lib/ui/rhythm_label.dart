import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';

class RhythmLabel extends StatelessWidget {

  const RhythmLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      // permet d'accéder à la valeur actualisée du rythme
      RhythmProvider.of(context).rhythm.toString(),
      style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.normal,
          color: Colors.orange
      ),
    );
  }
}