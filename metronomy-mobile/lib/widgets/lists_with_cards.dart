import 'package:flutter/material.dart';
import 'package:metronomy/store/rhythm_provider.dart';

class ListsWithCards extends StatelessWidget {
  const ListsWithCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Scrollbar(
        child: ListView.builder(
          itemCount: RhythmProvider.of(context).selectedSong.musiquePart.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Column(children: [
                    Text(
                      "${RhythmProvider.of(context).selectedSong.musiquePart[index].sectionName}(${RhythmProvider.of(context).selectedSong.musiquePart[index].sectionShortcut})",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ]),
                  Expanded(
                    child: Container(),
                  ),
                  Column(children: [
                    Text(
                      "${RhythmProvider.of(context).selectedSong.musiquePart[index].maximumBarsSection} temps",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ]),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
