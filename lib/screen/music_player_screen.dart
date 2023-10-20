import 'dart:async';

import 'package:Metronomy/design/color_schemes.g.dart';
import 'package:Metronomy/design/theme.dart';
import 'package:Metronomy/model/music_structure.dart';
import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/songs_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {

  const MusicPlayerScreen({super.key});

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {

  final player = AudioPlayer();

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

  Timer? _timerBPM;
  Duration? bpmDuration;

  int valueCountdown = 0;
  int oldValue = 0;
  var allValue = [];
  int _startingCountdown = 10;
  int _debugHitCount = 0;

  late Future<void> _songsFuture;
  var songsAvailable;

  bool _timeOne = false;
  bool _timeTwo = false;
  bool _timeThree = false;
  bool _timeFour = false;

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
        
        /*appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Row(children: [
            Icon(Icons.music_note),
            SizedBox(width: 15),
            Text('Metronomy',
            style: TextStyle(
            color: Color(0xFFFFC601),
            fontFamily: 'StarsAndLoveBottomHeavy',

            )
              

            )
          ]),
        ),*/
        body : SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.light ?
              'assets/images/MotifsBlancs.png' : 'assets/images/MotifsNoirs.png',
              color: Theme.of(context).brightness == Brightness.light?
              Colors.black.withOpacity(1): Colors.white.withOpacity(1),
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.cover,
              ),
              
            
          
          ListView(
          
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
                      Flex(
                        direction: 
                        MediaQuery.of(context).orientation == Orientation.landscape ?
                        Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Titre : ',
                            style: TextStyle(
                              color: Colors.black
                            )
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
              Flex(
                direction: 
                MediaQuery.of(context).orientation == Orientation.landscape ?
                Axis.horizontal: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Partie : ',
                    style: TextStyle(
                              color: Colors.black
                            )
                  ),
                  Text(
                    '${songsAvailable[0].musiquePart[_sectionCurrentIndex].sectionName}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              AnimatedOpacity(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                opacity: _startingCountdown ==0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                // The green box must be a child of the AnimatedOpacity widget.
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Mesure : ',
                          style: TextStyle(
                              color: Colors.black
                            )
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
                        const Text(
                          'Temps: ',
                          style: TextStyle(
                              color: Colors.black
                            )
                        ),
                        Text(
                          '$_beatCounter / ${songsAvailable[0].musiquePart[_sectionCurrentIndex].maximumBeatSection}',
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
                              const Text(
                                'Tempo : ',
                                style: TextStyle(
                              color: Colors.black
                            )
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

             Column( 
              mainAxisAlignment : MainAxisAlignment.center,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Starting countdown : ',
                    style: TextStyle(
                              color: Colors.black
                            )
                  ),
                  Text(
                    '$_startingCountdown',
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
                  const Text(
                    'Debug hit count : ',
                    style: TextStyle(
                              color: Colors.black
                            )
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
              )
              ],
             )
            ],
          ),
          ],
        
        ),
        ),
       
        
        floatingActionButton: Flex(
          direction: 
          MediaQuery.of(context).orientation == Orientation.landscape ? 
          Axis.horizontal : Axis.horizontal,
          mainAxisAlignment: MediaQuery.of(context).orientation == Orientation.landscape ? 
          MainAxisAlignment.end : MainAxisAlignment.center,        
          children: [
            FloatingActionButton(
              enableFeedback: false,
              onPressed: _playOrPause,
              tooltip: 'Play',
              backgroundColor: Colors.orangeAccent,
              child: Icon(_timerBPM != null && _timerBPM!.isActive ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(width: 8.0),
            FloatingActionButton(
              onPressed: stopTimer,
              tooltip: 'Stop',
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.stop),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )
    );
  }



  void setCountDown(double time1microsecond) {

    setState(() {

      if(_startingCountdown > 0){
        _startingCountdown--;
      }else {
        _debugHitCount++;
      }

      DateTime now = DateTime.now();

      int minute = now.minute;
      int second = now.second;
      int millisecond = now.millisecond;
      int microsecond = now.microsecond;

      int sumInMicrosecond = (minute * 60 * 1000000) + second * 1000000 + millisecond * 1000 + microsecond;

      String stringMinute = '${minute}';
      String stringsecond = '${second}';
      String stringmillisecond = '${millisecond}';
      String stringmicrosecond = '${microsecond}';

      int gradian = sumInMicrosecond - oldValue;
      allValue.add(gradian);

      print('${now} // ${stringMinute.padLeft(2,'0')}:${stringsecond.padLeft(2,'0')}.${stringmillisecond.padLeft(3,'0')}${stringmicrosecond.padLeft(3,'0')} soit > : ${sumInMicrosecond} - ${oldValue} = ${gradian} // soit ${((gradian / time1microsecond.toInt()) -1)} %');

      // play the tick song
      if(_debugHitCount > 0) {
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
        } else if (!_timeTwo) {
          _timeTwo = !_timeTwo;
        } else if (!_timeThree) {
          _timeThree = !_timeThree;
        } else if (!_timeFour) {
          _timeFour = !_timeFour;
        } else {
          _timeOne = true;
          _timeTwo = false;
          _timeThree = false;
          _timeFour = false;
        }
      }

      player.play(AssetSource('metronome-song.mp3'));

      oldValue = sumInMicrosecond;
    });
  }

  void _playOrPause() {

    if(_timerBPM != null && _timerBPM!.isActive){
      pauseTimer();
    }else{
      startTimer();
    }
  }

  void startTimer(){
    int mouvementParMinute = songsAvailable[0].tempo;
    double time1microsecond = 60 * 1000000 / mouvementParMinute;
    print("Debug (60 * 1 000 000 microseconds / ${mouvementParMinute} mvt par min) = ${time1microsecond.toInt()} microseconds");
    bpmDuration = Duration(microseconds: time1microsecond.toInt());

    _timerBPM = Timer.periodic(bpmDuration!, (_) => setCountDown(time1microsecond));
  }

  void pauseTimer() {
    setState(() {
      _timerBPM!.cancel();
    });
  }

  void stopTimer() {

    setState(() {
      stopTimerState();
    });
  }

  void stopTimerState() {
    _startingCountdown = 10;
    _debugHitCount = 0;

    _timeOne = false;
    _timeTwo = false;
    _timeThree = false;
    _timeFour = false;
    _timerBPM!.cancel();

    // gestion current
    _sectionCurrentIndex = 0;
    _beatCounter = 0;
    _barsCurrentCounter = 0;
  }
}