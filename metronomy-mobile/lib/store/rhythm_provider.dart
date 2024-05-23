import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:Metronomy/model/constants.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';

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
  int rhythm = kDefaultRhythm;
  bool enableTimer = kDefaultEnable;

  int _startingBarsNumber = kDefaultStartingBarsNumber;

  int startingCountdown = kDefaultStartingCountdown;
  int debugTickCount = 0;
  int _songIndex = 0;
  int _sectionCurrentIndex = 0;
  int _barsCurrentCounter = 1;
  int _maximumBarsSection = 0;
  int _sectionsLength = 0;

  late Song selectedSong;

  @override
  void initState() {
    _startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;

    super.initState();
  }

  void updateRhythm(int val) {
    setState(() {
      rhythm = val;
    });
  }

  void updateEnableTimer(bool value) {
    setState(() {
      enableTimer = value;

      Wakelock.toggle(enable: enableTimer);

      if (startingCountdown == kDefaultStartingCountdown) {
        resetStartingCountdown();
      }
    });
  }

  void updateStopTimer() {
    setState(() {
      enableTimer = false;
      resetStartingCountdown();
      debugTickCount = 0;
      _barsCurrentCounter = 1;
      _sectionCurrentIndex = 0;

      Wakelock.toggle(enable: enableTimer);
    });
  }

  void resetStartingCountdown() {
    // we add 1 to have a rang above 0
    // ie: beatsByBar == 7 && _startingBarsNumber == 2, the result will be 14 to 1
    //startingCountdown = selectedSong.beatsByBar * _startingBarsNumber + 1;

    // we add 1 to have a rang above 0
    // ie: beatsByBar == 7 && _startingBarsNumber == 2, the result will be 14 so the values fallow the range 13 to 0
    startingCountdown = selectedSong.beatsByBar * _startingBarsNumber + 1;
  }

  void updateMakeCountdown() {
    setState(() {
      if (startingCountdown > 0) {
        startingCountdown--;
      } else {
        debugTickCount++;

        // we increment _barsCurrentCounter when we are at tick n°1 of the a bar
        if (((debugTickCount + 1) % selectedSong.beatsByBar) == 1) {
          _barsCurrentCounter++;
        }

        if (_barsCurrentCounter > _maximumBarsSection) {
          if (_sectionCurrentIndex < (_sectionsLength - 1)) {
            // Nous sommes à la fin de la mesure (et du temps maxi de la dernière mesure), on doit donc passer à la partie suivante
            _barsCurrentCounter = 1;
            _sectionCurrentIndex++;
          } else {
            // this is the end of sections
            updateStopTimer();
          }
        }

        updateMusicInformations(
            _songIndex,
            selectedSong.musiquePart[_sectionCurrentIndex].maximumBarsSection,
            selectedSong.musiquePart.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RhythmStore(
      enable: enableTimer,
      debugTickCount: debugTickCount,
      songIndex: _songIndex,
      sectionCurrentIndex: _sectionCurrentIndex,
      barsCurrentCounter: _barsCurrentCounter,
      maximumBarsSection: _maximumBarsSection,
      sectionsLength: _sectionsLength,
      child: widget.child,
    );
  }

  void updateMusicInformations(
      int songIndex, int maximumBarsSection, int sectionsLength) {
    _songIndex = songIndex;
    _maximumBarsSection = maximumBarsSection;
    _sectionsLength = sectionsLength;
  }

  void updateSong(Song song, int indexOfSong) {
    selectedSong = song;
    rhythm = song.tempo;
    resetStartingCountdown();
    updateMusicInformations(
        indexOfSong,
        selectedSong.musiquePart[_sectionCurrentIndex].maximumBarsSection,
        selectedSong.musiquePart.length);
  }
}
