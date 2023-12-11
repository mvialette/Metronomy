import 'package:Metronomy/model/song.dart';
import 'package:flutter/material.dart';

class RhythmStore extends InheritedWidget {

  static RhythmStore of(BuildContext context) {
    final RhythmStore? result =
    context.dependOnInheritedWidgetOfExactType<RhythmStore>();

    if (result == null) {
      throw 'No RhythmStore found';
    }

    return result;
  }

  //final int rhythm;
  final bool enable;
  //final int startingCountdown;
  final int debugTickCount;

  final bool timeOne;
  final bool timeTwo;
  final bool timeThree;
  final bool timeFour;
  final bool timeFive;
  final bool timeSix;
  final bool timeSeven;

  final int songIndex;
  final int sectionCurrentIndex;
  final int barsCurrentCounter;
  final int maximumBarsSection;
  final int sectionsLength;

  const RhythmStore({
    super.key,
    required super.child,
    //required this.rhythm,
    required this.enable,
    //required this.startingCountdown,
    required this.debugTickCount,
    required this.timeOne,
    required this.timeTwo,
    required this.timeThree,
    required this.timeFour,
    required this.timeFive,
    required this.timeSix,
    required this.timeSeven,
    required this.songIndex,
    required this.sectionCurrentIndex,
    required this.barsCurrentCounter,
    required this.maximumBarsSection,
    required this.sectionsLength,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this == oldWidget;
    // TODO: implement updateShouldNotify
    //throw UnimplementedError();
  }

  /*@override
  bool updateShouldNotify(RhythmStore oldWidget) {
    return rhythm != oldWidget.rhythm;
  }*/
}