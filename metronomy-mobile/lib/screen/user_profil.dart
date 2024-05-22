
import 'dart:async';

import 'package:Metronomy/l10n/l10n.dart';
import 'package:Metronomy/providers/dark_mode_provider.dart';
import 'package:Metronomy/providers/locale_provider.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/screen/latency_definition_screen.dart';
import 'package:Metronomy/widgets/bullets_countdown.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:Metronomy/model/constants.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserProfilScreen extends ConsumerStatefulWidget {
  UserProfilScreen({
    super.key,
  });

  final AudioPlayer audioPlayerLowPitchedSound = AudioPlayer()
    ..setPlayerMode(
      PlayerMode.lowLatency,
    );

  @override
  ConsumerState<UserProfilScreen> createState() => _UserProfilScreenState();
}

class _UserProfilScreenState extends ConsumerState<UserProfilScreen> {
  late AudioPlayer player = AudioPlayer();

  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;
  late String languageCode;
  int durationReference = 0;
  int testBpm = 85;
  int bluetoothDelay = 0;
  //int bluetoothTestCounter = 0;
  int bluetoothTestLatencyOld = 0;
  int bluetoothTestLatencyNew = 0;

  var bluetoothTestLatencyMesure = <int>{};

  Timer? periodicTimer;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    debuggingMode = ref.read(allSettingsProvider).debuggingMode;

    // Create the audio player.
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(songLow);
      // await player.resume();
    });

    super.initState();
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();
    super.dispose();
  }

  void startTimer() {

    Duration duration = Duration(microseconds: durationReference);
    // Duration duration =
    //     Duration(milliseconds: (60000/testBpm).toInt());

    periodicTimer?.cancel();
    periodicTimer = new Timer.periodic(duration, (timer) async {
      player.pause();
      player.seek(Duration.zero);
      await player.resume();
    });
  }

  Future<void> _play() async {
    startTimer();
  }

  Future<void> _showDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Latency definition'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Text(
                  'Allow to define a letency between graphical display and song tick.  If you are using a bluetooth earing, you may need some latency between the display & the song.',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),

                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            periodicTimer!.cancel();
                            bluetoothDelay = bluetoothDelay - 5;
                            startTimer();
                          });
                        },
                        child: Text("-5")),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            periodicTimer!.cancel();
                            bluetoothDelay = bluetoothDelay - 1;
                            startTimer();
                          });
                        },
                        child: Text("-1")),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            periodicTimer!.cancel();
                            bluetoothDelay = bluetoothDelay + 1;
                            startTimer();
                          });
                        },
                        child: Text("+1")),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            periodicTimer!.cancel();
                            bluetoothDelay = bluetoothDelay + 5;
                            startTimer();
                          });
                        },
                        child: Text("+5")),
                  ],
                ),
                Slider(
                  divisions: 1000,
                  min: -1000,
                  max: 1000,
                  // utiliser RhythmStore pour RÉCUPÉRER la valeur du rythme
                  value: bluetoothDelay.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      periodicTimer!.cancel();
                      bluetoothDelay = value.toInt();
                      startTimer();
                      //saveLatency();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          (durationReference / 1000).toInt().toString(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'ms de référence (85 bpm)',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          bluetoothDelay.toString(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'ms avec latence mesurée',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                // Icon(
                //   true
                //       ? Icons.radio_button_on_rounded
                //       : Icons.radio_button_off_rounded,
                //   color: Theme.of(context).colorScheme.primary,
                //   size: 30,
                // ),
                // SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: _play,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Mesurer la latence',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '(85 bpm)',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(
                  height: 20,
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: SpinKitPulse(
                //     color: Theme.of(context).colorScheme.primary,
                //     size: 100.0,
                //     //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    bluetoothTestLatencyNew = DateTime.now().millisecondsSinceEpoch;

                    int diff = bluetoothTestLatencyNew - bluetoothTestLatencyOld;
                    if(diff > 2000) {
                      //on ne doit rien faire
                      bluetoothTestLatencyOld = bluetoothTestLatencyNew;
                    } else {
                      bluetoothTestLatencyMesure.add(diff);
                      bluetoothTestLatencyOld = bluetoothTestLatencyNew;
                      //bluetoothTestCounter++;

                      //int average = getBluetoothTestLatencyMesureAverage();
                      //print('counter : ${bluetoothTestCounter} == ${diff}, avg = ${average}');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volume_up_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'J\'entends',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    periodicTimer!.cancel();
                    setState(() {
                      int average = getBluetoothTestLatencyMesureAverage();
                      bluetoothDelay = average;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stop),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Stopper la mesure',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                ),
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                if(periodicTimer != null){
                  periodicTimer?.cancel();
                };

                setState(() {
                  int durationReferenceInt = (durationReference / 1000).toInt();
                  int bluetoothTestLatencyMesureAverage = getBluetoothTestLatencyMesureAverage();

                  bluetoothDelay = bluetoothTestLatencyMesureAverage - durationReferenceInt;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int getBluetoothTestLatencyMesureAverage(){
    int latencySum = 0;
    for (final oneLatency in bluetoothTestLatencyMesure) {
      latencySum = latencySum + oneLatency;
    }
    if(latencySum == 0){
      return getDurationReferenceInMs();
    }else{
      return (latencySum / bluetoothTestLatencyMesure.length).toInt();
    }
  }

  int getDurationReferenceInMs(){
    return (((60 / testBpm) * 1000)).toInt();
  }

  int getDurationReferenceInMicroseconds(){
    return (((60 / testBpm) * 1000) * 1000).toInt();
  }

  @override
  Widget build(BuildContext context) {

    durationReference = getDurationReferenceInMicroseconds();

    var darkMode = ref.watch(darkModeProvider);
    final locale = Localizations.localeOf(context);
    languageCode = locale.languageCode;

    User? user = FirebaseAuth.instance.currentUser;

    final displayName = user != null ? user.displayName : "toto";
    final userEmail = user != null ? user.email : "toto";
    final userImage = user?.photoURL;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.myAccount,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (userImage == null)
                    Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 80,
                    )
                  else
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: Image.network(userImage!).image,
                      backgroundColor: Colors.transparent,
                    ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person,
                      color: Theme.of(context).colorScheme.secondary),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    displayName.toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email,
                      color: Theme.of(context).colorScheme.secondary),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    userEmail.toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.languageLabel,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: L10n.all.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                      height: 50,
                      child: Center(
                          child: Row(children: [
                        Radio(
                          value: L10n.all[index].languageCode,
                          groupValue: languageCode,
                          onChanged: (String? value) {
                            ref.read(localeProvider.notifier).toggle(value!);
                          },
                        ),
                        Text(
                          L10n.getFlag(L10n.all[index].languageCode),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          L10n.all[index].languageCode ==
                                  L10n.all[0].languageCode
                              ? AppLocalizations.of(context)!.localEn
                              : AppLocalizations.of(context)!.localFr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        )
                      ])));
                }),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "${AppLocalizations.of(context)!.themeDarkMode} : ",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.latency + " (ms) : ",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    bluetoothDelay.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: 'Select this song en go to play mode',
                    onPressed: _showDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
