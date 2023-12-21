import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
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

  late Future<List<Song>> songsAvailable;

  int rhythm = kDefaultRhythm;
  bool enableTimer = kDefaultEnable;

  int _startingBarsNumber = kDefaultStartingBarsNumber;

  int startingCountdown = kDefaultStartingCountdown;
  int debugTickCount = 0;

  bool _timeOne = false;
  bool _timeTwo = false;
  bool _timeThree = false;
  bool _timeFour = false;
  bool _timeFive = false;
  bool _timeSix = false;
  bool _timeSeven = false;

  int _songIndex = 0;
  int _sectionCurrentIndex = 0;
  int _barsCurrentCounter = 0;
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
      if(startingCountdown == kDefaultStartingCountdown){
        resetStartingCountdown();
      }
    });
  }

  void updateStopTimer() {
    setState(() {
      enableTimer = false;
      resetStartingCountdown();
      debugTickCount = 0;
      _timeOne = false;
      _timeTwo = false;
      _timeThree = false;
      _timeFour = false;
      _timeFive = false;
      _timeSix = false;
      _timeSeven = false;
      _barsCurrentCounter = 0;
      _sectionCurrentIndex = 0;
    });
  }

  void resetStartingCountdown(){
    startingCountdown = selectedSong.beatsByBar * _startingBarsNumber;
  }

  void updateMakeCountdown() {

    setState(() {

      if(startingCountdown > 0){
        startingCountdown--;

        _timeOne = false;
        _timeTwo = false;
        _timeThree = false;
        _timeFour = false;
      }else{
        debugTickCount++;

        if (_timeOne) {
          _timeOne = false;
          _timeTwo = true;
        } else if (_timeTwo) {
          _timeTwo = false;
          _timeThree = true;
        } else if (_timeThree) {
          _timeThree = false;
          if(selectedSong.beatsByBar == 3) {
            _timeOne = true;
            _barsCurrentCounter++;
          } else {
            _timeFour = true;
          }
        } else if (_timeFour) {
          _timeFour = false;
          if(selectedSong.beatsByBar == 4) {
            _timeOne = true;
            _barsCurrentCounter++;
          } else {
            _timeFive = true;
          }
        } else if (_timeFive) {
          _timeFive = false;
          if(selectedSong.beatsByBar == 5) {
            _timeOne = true;
            _barsCurrentCounter++;
          } else {
            _timeSix = true;
          }
        } else if (_timeSix) {
          _timeSix = false;
          if(selectedSong.beatsByBar == 5) {
            _timeOne = true;
            _barsCurrentCounter++;
          } else {
            _timeSeven = true;
          }
        } else if (_timeSeven) {
          _timeSeven = false;
          _timeOne = true;
          _barsCurrentCounter++;
        } else {
          // All flags are set to false
          _timeOne = true;
        }

        if(_barsCurrentCounter >  _maximumBarsSection) {
          if(_sectionCurrentIndex < (_sectionsLength -1)) {
            // Nous sommes à la fin de la mesure (et du temps maxi de la dernière mesure), on doit donc passer à la partie suivante
            _barsCurrentCounter = 1;
            _sectionCurrentIndex++;
          }else{
            // this is the end of sections
            updateStopTimer();
          }
        }

        updateMusicInformations(_songIndex, selectedSong.musiquePart[_sectionCurrentIndex].maximumBarsSection, selectedSong.musiquePart.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return RhythmStore(
      child: widget.child,
      //rhythm: _rhythm,
      enable: enableTimer,
      debugTickCount: debugTickCount,
      timeOne: _timeOne,
      timeTwo: _timeTwo,
      timeThree: _timeThree,
      timeFour: _timeFour,
      timeFive: _timeFive,
      timeSix: _timeSix,
      timeSeven: _timeSeven,
      songIndex: _songIndex,
      sectionCurrentIndex: _sectionCurrentIndex,
      barsCurrentCounter: _barsCurrentCounter,
      maximumBarsSection: _maximumBarsSection,
      sectionsLength: _sectionsLength,
    );
  }

  void updateMusicInformations(int songIndex, int maximumBarsSection, int sectionsLength) {
      _songIndex = songIndex;
      _maximumBarsSection = maximumBarsSection;
      _sectionsLength = sectionsLength;
  }

  void updateSong(Song song, int indexOfSong) {
    selectedSong = song;
    rhythm = song.tempo;
    resetStartingCountdown();
    updateMusicInformations(indexOfSong, selectedSong.musiquePart[_sectionCurrentIndex].maximumBarsSection, selectedSong.musiquePart.length);
  }
}