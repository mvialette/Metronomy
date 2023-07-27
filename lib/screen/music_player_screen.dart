import 'dart:async';

import 'package:Metronomy/model/music_structure.dart';
import 'package:Metronomy/model/song.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget{

  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {

  int _counterDebug = 0;

  // music section details
  MusicStructure _musicStructureIntro = new MusicStructure("INTRO", "I", 16, 4);
  MusicStructure _musicStructureVerse = new MusicStructure("VERSE", "V", 16, 4);
  MusicStructure _musicStructureBreakdown = new MusicStructure("BREAKDOWN", "BD", 8, 4);
  MusicStructure _musicStructureBuildUp = new MusicStructure("BUILD UP", "BU", 8, 4);
  MusicStructure _musicStructureChorus = new MusicStructure("CHORUS", "C", 16, 4);
  MusicStructure _musicStructureOutro = new MusicStructure("OUTRO", "O", 22, 4);

  Song? myCurrentSong;

  // the list (aka the sample)
  List<MusicStructure> list = [];
  MusicStructure _musicStructureCurrent = new MusicStructure("INTRO", "I", 16, 4);

  int _sectionCurrentIndex = 0;
  int _beatCounter = 0;
  int _barsCurrentCounter = 0;

  int debugTempsDActionNmoinsUn = 0;
  int debugTempsAvgMin = 0;
  int debugTempsAvgMax = 0;

  double _bpm = 140;
  int _tickInterval = 0;
  Timer? _tickTimer;

  void _play() {

    int tempsDAction = DateTime.now().millisecondsSinceEpoch;
    if(debugTempsDActionNmoinsUn == null) {
      debugTempsDActionNmoinsUn = tempsDAction;
    }

    int debugTempsAvgCurrent = tempsDAction - debugTempsDActionNmoinsUn;

    if(debugTempsAvgMin > debugTempsAvgCurrent || debugTempsAvgMin ==0) {
      debugTempsAvgMin = debugTempsAvgCurrent;
    }
    if(debugTempsAvgMax < debugTempsAvgCurrent && debugTempsAvgCurrent < 20000) {
      debugTempsAvgMax = debugTempsAvgCurrent;
    }else if(debugTempsAvgMax < debugTempsAvgCurrent && debugTempsAvgCurrent > 20000) {
      debugTempsAvgMax = 0;
    }

    //print('run: now : $tempsDAction / n-1 : $debugTempsDActionNmoinsUn / diff = $debugTempsAvgCurrent / min = $debugTempsAvgMin / max = $debugTempsAvgMax');
    debugTempsDActionNmoinsUn = tempsDAction;

    _counterDebug++;
    _beatCounter++;

    if(_beatCounter > _musicStructureCurrent.maximumBeatSection){
      if(_barsCurrentCounter >= _musicStructureCurrent.maximumBarsSection){
        // on test pour vérifier qu'on ne soit pas à la fin du morceau
        if(_sectionCurrentIndex < (list.length -1)) {
          // Nous sommes à la fin de la mesure (et du temps maxi de la dernière mesure), on doit donc passer à la partie suivante
          _sectionCurrentIndex++;
          _musicStructureCurrent = list[_sectionCurrentIndex];
          _barsCurrentCounter = 0;
          _beatCounter = 1;
        }
      }
      _barsCurrentCounter++;
      _beatCounter = 1;
    }
    //});
    _playSong();
  }

  @override
  Widget build(BuildContext context) {

    List<MusicStructure> aaaa =  <MusicStructure>[];
    aaaa.add(_musicStructureIntro);
    aaaa.add(_musicStructureChorus);
    myCurrentSong = new Song("My Way", 222, aaaa);

    list = [_musicStructureIntro, _musicStructureVerse, _musicStructureBreakdown, _musicStructureBuildUp, _musicStructureChorus, _musicStructureOutro];

    int beatPerMilliseconds = (60 * 1000 / _bpm.toInt()).round();
    Duration beatPerMillisecondsDuration = Duration(milliseconds: beatPerMilliseconds);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(children: [
            Icon(Icons.music_note),
            SizedBox(width: 15),
            Text('Metronomy')
          ]),
        ),
        body: Center(


          child: Column(

            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Titre : ',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '${myCurrentSong?.title}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                          color: Colors.orange
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Partie : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${_musicStructureCurrent.sectionName}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mesure : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '$_barsCurrentCounter / ${_musicStructureCurrent.maximumBarsSection}' ,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Temps: ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '$_beatCounter / ${_musicStructureCurrent.maximumBeatSection}',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.radio_button_on_rounded, color: Theme.of(context).colorScheme.primary),
                  Icon(Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                  Icon(Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                  Icon(Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child:
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tempo : ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '${_bpm.toInt()}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.orange
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Slider(
                          min: 1.0,
                          max: 220.0,
                          activeColor: Colors.orangeAccent,
                          inactiveColor: Colors.orange.shade50,
                          thumbColor: Colors.orange,
                          value: _bpm,
                          onChanged: (value) {
                            setState(() {
                              _bpm = value;

                              if(_tickTimer != null && _tickTimer!.isActive) {
                                double bps = _bpm.toInt() / 60;
                                _tickInterval = 1000 ~/ bps;
                                if(_tickTimer != null){
                                  // clean the previous timer instance
                                  _tickTimer!.cancel();
                                }
                                // start a new timer with the new _tickInterval
                                _tickTimer = new Timer.periodic(
                                    new Duration(milliseconds: _tickInterval),
                                    _onTick);
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () => _playOrPause(beatPerMillisecondsDuration),
              tooltip: 'Play',
              backgroundColor: Colors.orangeAccent,
              child: Icon(_tickTimer != null && _tickTimer!.isActive ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(width: 8.0),
            FloatingActionButton(
              onPressed: () => _stop(),
              tooltip: 'Stop',
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.stop),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )
    );
  }

  void _onTick(Timer t) {
    _musicStructureCurrent = list[_sectionCurrentIndex];

    if (_sectionCurrentIndex == (list.length - 1) && _barsCurrentCounter >= _musicStructureCurrent.maximumBarsSection && _beatCounter >= _musicStructureCurrent.maximumBeatSection) {
      _stop();
    } else {
      _play();
    }

    if (mounted) setState(() {});
  }

  void _playOrPause(Duration duration) {

    if(_tickTimer != null && _tickTimer!.isActive){
      _pause();
    }else{
      _musicStructureCurrent = list[_sectionCurrentIndex];

      double bps = _bpm.toInt()/60;
      _tickInterval = 1000~/bps;
      _tickTimer = Timer.periodic(new Duration(milliseconds: _tickInterval), _onTick);
    }
  }

  void _pause() {
    setState(() {
      _tickTimer!.cancel();
    });
  }

  void _stop() {
    // call by the end of playlist, or onPressed over stop widget
    setState(() {
      _sectionCurrentIndex = 0;
      _musicStructureCurrent = list[_sectionCurrentIndex];
      _beatCounter = 0;
      _barsCurrentCounter = 0;

      _tickTimer!.cancel();
    });
  }

  void _playSong() {
    final player = AudioPlayer();
    player.play(AssetSource('metronome-song.mp3'));
  }
}