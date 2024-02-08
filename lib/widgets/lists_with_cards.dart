import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter/material.dart';

class ListsWithCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
                Text(RhythmProvider
                    .of(context)
                    .selectedSong
                    .musiquePart[index]
                    .sectionName +
                    "(" +
                    RhythmProvider
                        .of(context)
                        .selectedSong
                        .musiquePart[index]
                        .sectionShortcut +
                    ")",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),),
              ]),
              Expanded(
                child: Container(),
              ),
              Column(
                  children: [
                    Text(RhythmProvider
                        .of(context)
                        .selectedSong
                        .musiquePart[index]
                        .maximumBarsSection
                        .toString() + " temps",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                      ),),
                  ]),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        );
      },
    ),);
  }
}
