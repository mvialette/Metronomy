import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';

class ListsWithCards extends StatelessWidget {
  const ListsWithCards({super.key});


  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: RhythmProvider.of(context).selectedSong.musiquePart.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${RhythmProvider.of(context).selectedSong.musiquePart[index].sectionName}(${RhythmProvider.of(context).selectedSong.musiquePart[index].sectionShortcut}) = ${RhythmProvider.of(context).selectedSong.musiquePart[index].maximumBarsSection} bars"),
        );
      },
    );
  }
}