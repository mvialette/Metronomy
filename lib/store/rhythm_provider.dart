import 'package:Metronomy/providers/songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RhythmProvider extends ConsumerStatefulWidget {
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
  ConsumerState<RhythmProvider> createState() => RhythmProviderState();
}

class RhythmProviderState extends ConsumerState<RhythmProvider> {

  var songsAvailable;

  int _rhythm = kDefaultRhythm;
  bool _enable = kDefaultEnable;

  int _startingCountdown = kDefaultStartingCountdown;
  int _debugTickCount = 0;

  bool _timeOne = false;
  bool _timeTwo = false;
  bool _timeThree = false;
  bool _timeFour = false;

  int _songIndex = 0;
  int _sectionCurrentIndex = 0;
  int _beatCounter = 0;
  int _barsCurrentCounter = 0;

  @override
  void initState() {
    ref.read(songsProvider.notifier).loadSongs();
    super.initState();
  }
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

  void updateStopTimer() {
    setState(() {
      _enable = false;
      _startingCountdown = kDefaultStartingCountdown;
      _debugTickCount = 0;
      _timeOne = false;
      _timeTwo = false;
      _timeThree = false;
      _timeFour = false;
      _barsCurrentCounter = 0;
    });
  }

  void updateMakeCountdown() {
    setState(() {

      if(_startingCountdown > 0){
        _startingCountdown--;

        _timeOne = false;
        _timeTwo = false;
        _timeThree = false;
        _timeFour = false;
      }else{
        _debugTickCount++;

        if (_timeOne) {
          _timeOne = false;
          _timeTwo = true;
        } else if (_timeTwo) {
          _timeTwo = false;
          _timeThree = true;
        } else if (_timeThree) {
          _timeThree = false;
          _timeFour = true;
        } else {
          _timeFour = false;
          _timeOne = true;
          _barsCurrentCounter++;
        }

        /*if (!_timeOne) {
          // premiere mesure (bar), premier temps (beat)
          _timeOne = !_timeOne;
          _barsCurrentCounter++;
        } else if (!_timeTwo) {
          _timeTwo = !_timeTwo;
        } else if (!_timeThree) {
          _timeThree = !_timeThree;
        } else if (!_timeFour) {
          _timeFour = !_timeFour;
        } else {
          // mesure suivante (bar), premier temps (beat)
          _barsCurrentCounter++;
          _timeOne = true;
          _timeTwo = false;
          _timeThree = false;
          _timeFour = false;
        }

        */

        if(_barsCurrentCounter >  songsAvailable[_songIndex].musiquePart[_sectionCurrentIndex].maximumBarsSection) {
          if(_sectionCurrentIndex < (songsAvailable[_songIndex].musiquePart.length -1)) {
            // Nous sommes à la fin de la mesure (et du temps maxi de la dernière mesure), on doit donc passer à la partie suivante
            _barsCurrentCounter = 1;
            _sectionCurrentIndex++;
          }else{
            // this is the end of sections
            updateStopTimer();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    songsAvailable = ref.watch(songsProvider);
    return RhythmStore(
      child: widget.child,
      rhythm: _rhythm,
      enable: _enable,
      startingCountdown: _startingCountdown,
      debugTickCount: _debugTickCount,
      timeOne: _timeOne,
      timeTwo: _timeTwo,
      timeThree: _timeThree,
      timeFour: _timeFour,
      songIndex: _songIndex,
      sectionCurrentIndex: _sectionCurrentIndex,
      barsCurrentCounter: _barsCurrentCounter,
      beatCounter: _beatCounter,
    );
  }

  void updateMusicInformations(int songIndex, int maximumBeatSection, int maximumBarsSection) {
    setState(() {
      _songIndex = songIndex;
      _sectionCurrentIndex = 0;
      _beatCounter = maximumBeatSection;
      _barsCurrentCounter = maximumBarsSection;
    });
  }
}