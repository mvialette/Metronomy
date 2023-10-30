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

  final int rhythm;
  final bool enable;
  final int startingCountdown;

  const RhythmStore({
    super.key,
    required super.child,
    required this.rhythm,
    required this.enable,
    required this.startingCountdown,
  });

  @override
  bool updateShouldNotify(RhythmStore oldWidget) {
    return rhythm != oldWidget.rhythm;
  }
}