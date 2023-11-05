import 'package:flutter/material.dart';
import 'package:Metronomy/store/rhythm_store.dart';

class RhythmLabel extends StatelessWidget {

  const RhythmLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      // permet d'accéder à la valeur actualisée du rythme
      RhythmStore.of(context).rhythm.toString(),
      style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.normal,
          color: Colors.orange
      ),
    );
  }
}