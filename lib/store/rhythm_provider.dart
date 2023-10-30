import 'package:flutter/material.dart';
import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/store/rhythm_store.dart';

class RhythmProvider extends StatefulWidget {
  static RhythmProviderState of(BuildContext context) {
    final result = context.findAncestorStateOfType<RhythmProviderState>();
    if (result == null) {
      throw 'RythmProviderState ancestor has not been found';
    }

    return result;
  }

  final Widget child;

  const RhythmProvider({
    super.key,
    required this.child,
  });

  @override
  State<RhythmProvider> createState() => RhythmProviderState();
}

class RhythmProviderState extends State<RhythmProvider> {
  int _rhythm = kDefaultRhythm;
  bool _enable = kDefaultEnable;
  int _startingCountdown = kDefaultStartingCountdown;

  void updateRhythm(int val) {
    setState(() {
      _rhythm = val;
    });
  }

  void updateEnableTimer(bool value) {
    setState(() {
      _enable = value;
    });
  }

  void updateDowngradeCountdown() {
    setState(() {
      if(_startingCountdown > 0){
        _startingCountdown--;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return RhythmStore(
      rhythm: _rhythm,
      enable: _enable,
      startingCountdown: _startingCountdown,
      child: widget.child,
    );
  }
}