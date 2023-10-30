import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/songs_provider.dart';
import 'package:Metronomy/store/rhythm_store.dart';
import 'package:Metronomy/ui/rhythm_label.dart';
import 'package:Metronomy/ui/rhythm_slider.dart';
import 'package:Metronomy/ui/sound_toggle_button.dart';
import 'package:Metronomy/ui/stop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const millisecondsPerMinute = 60000;
const microsecondsPerMinute = 60000000;

class MusicPlayerScreen extends ConsumerStatefulWidget {

  const MusicPlayerScreen({super.key});

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {

  bool printDebug = false;

  Song? myCurrentSong;

  int _sectionCurrentIndex = 0;
  int _beatCounter = 0;
  int _barsCurrentCounter = 0;

  int debugTempsDActionNmoinsUn = 0;
  int debugTempsAvgMin = 0;
  int debugTempsAvgMax = 0;

  double _bpm = 60;
  int _tickInterval = 0;

  /*(timer) {
  var now = DateTime.now().microsecondsSinceEpoch;
  var duration = now - timeenmicrosecsinceepochprevioustick;
  //print('debug : tick = ${timer.tick} // now = ${now}');
  if (duration >= intervalInMicrosecond) {
  _onTimerTick();
  //if (ticksOverall >= sampleSize) return;
  //print('debug : tick = ${timer.tick} // now = ${now} // timeenmicrosecsinceepochprevioustick = ${timeenmicrosecsinceepochprevioustick} // diff = ${duration}');
  timeenmicrosecsinceepochprevioustick = now;
  }
  },
  );*/

  Duration? bpmDuration;

  int valueCountdown = 0;
  int oldValuePrint = 0;
  int oldValueCount = 0;
  var allValue = [];
  int _startingCountdown = 10;
  int _debugHitCount = 0;

  late Future<void> _songsFuture;
  var songsAvailable;

  bool _timeOne = false;
  bool _timeTwo = false;
  bool _timeThree = false;
  bool _timeFour = false;

  /////////////
  var sampleSize = 25;

  static const _defaultBpm = 60;

  var bpm = _defaultBpm;
  //var intervalInMilliseconds = millisecondsPerMinute / _defaultBpm;
  var intervalInMicrosecond = microsecondsPerMinute / _defaultBpm;

  Timer? timer;
  Isolate? isolate;
  int millisLastTick = 0;

  double overallDeviation = 0;
  var inAccurateTicks = 0;
  // defaults to -1, since there is natural delay between starting the timer or isolate and it's first tick
  var ticksOverall = -1;
  var timeenmicrosecsinceepochprevioustick = -1;

  List<String> deviationInfo = [];

  @override
  void initState() {
    _songsFuture = ref.read(songsProvider.notifier).loadSongs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    songsAvailable = ref.watch(songsProvider);
    myCurrentSong = songsAvailable[0];

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
                  FutureBuilder(
                    future: _songsFuture,
                    builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting ?
                      const Center(
                        child: CircularProgressIndicator()
                      ) :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Titre : ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '${songsAvailable[0].title}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.normal,
                                color: Colors.orange
                            ),
                          ),
                        ],
                      ),
                  )
              ),
              SizedBox(height: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Partie : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${songsAvailable[0].musiquePart[_sectionCurrentIndex].sectionName}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: RhythmStore.of(context).startingCountdown == 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                // The green box must be a child of the AnimatedOpacity widget.
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mesure : ',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '$_barsCurrentCounter / ${songsAvailable[0].musiquePart[_sectionCurrentIndex].maximumBarsSection}' ,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_timeOne?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                        Icon(_timeTwo?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                        Icon(_timeThree?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
                        Icon(_timeFour?Icons.radio_button_on_rounded:Icons.radio_button_off_rounded, color: Theme.of(context).colorScheme.primary),
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
                                '${songsAvailable[0].tempo}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.orange
                                ),
                              ),
                            ],
                          ),
                          /*Row(
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
                   ), */
                        ],
                      ),
                    ),
                  ],
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Starting countdown : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${RhythmStore.of(context).startingCountdown}',
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
                  Text(
                    'Debug hit count : ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '$_debugHitCount',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.orange
                    ),
                  ),
                ],
              ),
              RhythmLabel(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: RhythmSlider(),
              ),

            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoundToggleButton(),
            const SizedBox(width: 8.0),
            StopButton(),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )
    );
  }

  void setCountDown() async {

    setState(() {

      if(_startingCountdown > 0){
        _startingCountdown--;
      }else {
        _debugHitCount++;
      }

      bool first = false;
      // play the tick song
      if(_debugHitCount > 0 && _startingCountdown == 0) {
        _beatCounter++;
        if(_beatCounter > myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBeatSection){

          if(_barsCurrentCounter >=  myCurrentSong!.musiquePart[_sectionCurrentIndex].maximumBarsSection){
            // on test pour vérifier qu'on ne soit pas à la fin du morceau
            if(_sectionCurrentIndex < (myCurrentSong!.musiquePart.length -1)) {
              // Nous sommes à la fin de la mesure (et du temps maxi de la dernière mesure), on doit donc passer à la partie suivante
              _sectionCurrentIndex++;
              _barsCurrentCounter = 0;
              _beatCounter = 1;
            }else{
              stopTimerState();
            }
          }

          _beatCounter = 1;
          _barsCurrentCounter++;
        }

        if (!_timeOne) {
          _timeOne = !_timeOne;
          first = true;

        } else if (!_timeTwo) {
          _timeTwo = !_timeTwo;
        } else if (!_timeThree) {
          _timeThree = !_timeThree;
        } else if (!_timeFour) {
          _timeFour = !_timeFour;
        } else {
          first = true;
          _timeOne = true;
          _timeTwo = false;
          _timeThree = false;
          _timeFour = false;
        }

        if(first){
          //playerSongFirst.play(songFirst);
          print('1');
          //int streamId = await pool.play(soundId);
        }else{
          print('2/3/4');
          //int streamId = await pool.play(soundId);
          //playerSongNext.play(songNext);
        }
      }
    });
  }

  void startTimer(){
    int mouvementParMinute = songsAvailable[0].tempo;
    //double time1microsecond = 60 * 1000000 / mouvementParMinute;
    // double time1microsecond = 52000;
    //print("Debug (60 * 1 000 000 microseconds / environ ${mouvementParMinute} mvt par min) = ${time1microsecond.toInt()} microseconds");
    //print("Debug (60 * 1 000 000 microseconds / ${mouvementParMinute} mvt par min) = ${time1microsecond.toInt()} microseconds");
    //bpmDuration = Duration(microseconds: time1microsecond.toInt());

    /*int counter = 40;
    //Timer.periodic(const Duration(microseconds: 1000000), (timer) {

    int millisLastTick = 0;
    var now = DateTime.now().millisecondsSinceEpoch;
    var duration = now - millisLastTick;

    const millisecondsPerMinute = 60000;
    const _defaultBpm = 240;
    var intervalInMilliseconds = millisecondsPerMinute / _defaultBpm;*/


/*    _timerBPM = Timer.periodic(new Duration(milliseconds: 100), (testTimer) => {
    //_timerBPM = Timer.periodic(new Duration(milliseconds: 521739), (testTimer) => {
      _printMaintenant()
    });*/


    /*Timer.periodic( Duration(seconds: 2), (timer) {
      print(timer.tick);
      counter--;
      if (counter == 0) {
        print('Cancel timer');
        timer.cancel();
      }
    });*/


    /*_timerBPM = Timer.periodic(
      const Duration(microseconds: 200),
          (timer) {
        var now = DateTime.now().microsecondsSinceEpoch;
        var duration = now - timeenmicrosecsinceepochprevioustick;
        //print('debug : tick = ${timer.tick} // now = ${now}');
        if (duration >= intervalInMicrosecond) {
          _onTimerTick();
          //if (ticksOverall >= sampleSize) return;
          //print('debug : tick = ${timer.tick} // now = ${now} // timeenmicrosecsinceepochprevioustick = ${timeenmicrosecsinceepochprevioustick} // diff = ${duration}');
          timeenmicrosecsinceepochprevioustick = now;
        }

        //print('debug : tick = ${timer.tick} // now = ${now} // ticksOverall = ${ticksOverall} // sampleSize = ${sampleSize}');


        //_printMaintenant();

        *//*if (ticksOverall >= sampleSize) return;


        var duration = now - millisLastTick;

        if (duration >= intervalInMilliseconds) {
          _onTimerTick();

          millisLastTick = now;
        }*//*
      },
    );*/


  }

  void _onTimerTick() {
    _printMaintenant();
    setCountDown();

    /*if (ticksOverall >= sampleSize) return;

    ticksOverall++;

    var now = DateTime.now().microsecondsSinceEpoch;
    var duration = now - millisLastTick;*/

    /*// ignore the very first tick since there is natural delay between setting up the timer and the first tick
    if (duration != intervalInMicrosecond && ticksOverall > 0) {
      //var deviation = (duration - intervalInMicrosecond).abs();
      //deviationInfo.add('Deviation in tick #$ticksOverall - $deviation ms');
      _printMaintenant();

      inAccurateTicks++;
      overallDeviation += deviation;
    }

    millisLastTick = now;

    if (ticksOverall >= sampleSize) {
      onSamplingComplete();
    }*/
  }

  void _printMaintenant() {
    var nowDT = DateTime.now();
    var nowMicrosecondsSinceEpoch = nowDT.microsecondsSinceEpoch;
    int gradian = nowMicrosecondsSinceEpoch - oldValuePrint;
    print('${nowDT} // ${gradian /1000} microsec - ${intervalInMicrosecond /1000}  microsec = ${(gradian - intervalInMicrosecond) / 1000}  millisecondes ');

    if(_startingCountdown > 0){
     // playerSongNext.play(songNext);
    }
    oldValuePrint = nowMicrosecondsSinceEpoch;
  }

  void onSamplingComplete() {
    timer?.cancel();
    timer = null;

    isolate?.kill();
    isolate = null;

    var averageDeviation = overallDeviation / inAccurateTicks;

    for (var message in deviationInfo) print(message);

    print('Ticks $ticksOverall');
    print('Inaccurate ticks $inAccurateTicks');
    print('${((inAccurateTicks / ticksOverall) * 100).toStringAsFixed(2)}% in-accuracy');
    print('Average deviation ${averageDeviation.toStringAsFixed(5)} ms');
  }

  void stopTimerState() {
    _startingCountdown = 10;
    _debugHitCount = 0;

    _timeOne = false;
    _timeTwo = false;
    _timeThree = false;
    _timeFour = false;

    // gestion current
    _sectionCurrentIndex = 0;
    _beatCounter = 0;
    _barsCurrentCounter = 0;
  }
}