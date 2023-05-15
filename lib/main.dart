import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/MusicStructure.dart';

void main() {
  runApp(const MetronomyApp());
}

class MetronomyApp extends StatelessWidget {
  const MetronomyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metronomy App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
        useMaterial3: true,
      ),
      home: const MetronomyHomePage(title: 'Metronomy'),
    );
  }
}

class MetronomyHomePage extends StatefulWidget {
  const MetronomyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MetronomyHomePage> createState() => _MetronomyHomePageState();
}

class _MetronomyHomePageState extends State<MetronomyHomePage> {
  int _counterDebug = 0;

  // music section details
  MusicStructure _musicStructureIntro = new MusicStructure("INTRO", "I", 16, 4);
  MusicStructure _musicStructureVerse = new MusicStructure("VERSE", "V", 16, 4);
  MusicStructure _musicStructureBreakdown = new MusicStructure("BREAKDOWN", "BD", 8, 4);
  MusicStructure _musicStructureBuildUp = new MusicStructure("BUILD UP", "BU", 8, 4);
  MusicStructure _musicStructureChorus = new MusicStructure("CHORUS", "C", 16, 4);
  MusicStructure _musicStructureOutro = new MusicStructure("OUTRO", "O", 22, 4);

  // the list (aka the sample)
  List<MusicStructure> list = [];
  MusicStructure _musicStructureCurrent = new MusicStructure("INTRO", "I", 16, 4);

  int _sectionCurrentIndex = 0;
  int _beatCounter = 0;
  int _barsCountdown = 16;

  final int _bpm = 220;
  Timer? _timer;
  bool _countdownActive = false;

  void _play() {
    setState(() {
      _counterDebug++;
      _beatCounter++;

      if(_beatCounter > _musicStructureCurrent.maximumBeatMesure){
        _beatCounter = 1;
        _barsCountdown--;

        if(_barsCountdown == 0){
          _sectionCurrentIndex++;

          if(_sectionCurrentIndex < list.length) {
            _musicStructureCurrent = list[_sectionCurrentIndex];
            _barsCountdown = _musicStructureCurrent.barsRemaining;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    list = [_musicStructureIntro, _musicStructureVerse, _musicStructureBreakdown, _musicStructureBuildUp, _musicStructureChorus, _musicStructureOutro];

    int beatPerMilliseconds = (60 * 1000 / _bpm).round();
    Duration beatPerMillisecondsDuration = Duration(milliseconds: beatPerMilliseconds);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.orangeAccent,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Partie : ',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${_musicStructureCurrent.sectionName}',
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
                Text(
                  'Mesure : ',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_barsCountdown',
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
                Text(
                  'Temps: ',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_beatCounter',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            /* FIXME TODO : This line isn't mandatory, a clean code it better than comment, need to be removed ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Structure : ',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${_musicStructureIntro.sectionShortcut} - ${_musicStructureVerse.sectionShortcut} - ${_musicStructureBreakdown.sectionShortcut} - ${_musicStructureBuildUp.sectionShortcut} - ${_musicStructureChorus.sectionShortcut} - ${_musicStructureOutro.sectionShortcut}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            */
            Row(
              children: [
                SizedBox(
                  height: 30, //<-- SEE HERE
                ),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tempo : ',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_bpm',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange
                  ),
                ),
              ],
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
            child: Icon(_countdownActive ? Icons.pause : Icons.play_arrow),
          ),
          SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: () => _stop(),
            tooltip: 'Stop',
            backgroundColor: Colors.orangeAccent,
            child: Icon(Icons.stop),
          ),// This trailing comma makes auto-formatting nicer for build methods.
          /*FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.pause),
          ),*/ // This trailing comma makes auto-formatting nicer for build methods.
        ],
      )
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Not yet implemented'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _playOrPause(Duration duration) {

    if(_countdownActive){
      _pause();
    }else{
      _musicStructureCurrent = list[_sectionCurrentIndex];

      // exemple pour 60 secondes (aka 1 min) * 1000 (pour avoir le nb de millisecondes) / 80 (le nb de baptement par minutes ==> 750
      // exemple pour 60 secondes (aka 1 min) * 1000 (pour avoir le nb de millisecondes) / 220 (le nb de baptement par minutes ==> 272
      // en mode plus rapide
      // exemple pour 60 secondes (aka 1 min) * 1000 (pour avoir le nb de millisecondes) / 220 (le nb de baptement par minutes ==> 272

      _timer = new Timer.periodic(
          duration, (Timer timer) {
        if (_sectionCurrentIndex == list.length) {
          _stop();
        } else {
          _play();
        }
      });
    }

    _countdownActive = _timer!.isActive;
  }

  void _pause() {
    setState(() {
      _timer!.cancel();
    });
  }

  void _stop() {
    setState(() {
      _sectionCurrentIndex = 0;
      _musicStructureCurrent = list[_sectionCurrentIndex];
      _beatCounter = 0;
      _barsCountdown = 16;
      _countdownActive = false;

      _timer!.cancel();
    });
  }
}
