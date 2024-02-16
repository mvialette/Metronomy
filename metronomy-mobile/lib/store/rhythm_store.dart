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
}