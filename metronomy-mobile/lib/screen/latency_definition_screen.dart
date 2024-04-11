import 'package:Metronomy/l10n/l10n.dart';
import 'package:Metronomy/providers/dark_mode_provider.dart';
import 'package:Metronomy/providers/locale_provider.dart';
import 'package:Metronomy/providers/settings_notifier.dart';
import 'package:Metronomy/widgets/bullets_countdown.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LatencyDefinitionScreen extends ConsumerStatefulWidget {
  const LatencyDefinitionScreen({
    super.key,
  });

  @override
  ConsumerState<LatencyDefinitionScreen> createState() => _LatencyDefinitionScreenState();
}

class _LatencyDefinitionScreenState extends ConsumerState<LatencyDefinitionScreen> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;
  late String languageCode;
  int bluetoothDelay = 200;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    debuggingMode = ref.read(allSettingsProvider).debuggingMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var darkMode = ref.watch(darkModeProvider);
    final locale = Localizations.localeOf(context);
    languageCode = locale.languageCode;

    User? user = FirebaseAuth.instance.currentUser;

    // Stream documentStream = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user!.uid)
    //     .snapshots();

    //int lacencyFromFirebase = documentStream.get(FieldPath(['latency']));

    final displayName = user != null ? user.displayName : "toto";
    final userEmail = user != null ? user.email : "toto";
    final userImage = user != null ? user.photoURL : null;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
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
                  Text(bluetoothDelay.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    true
                        ? Icons.radio_button_on_rounded
                        : Icons.radio_button_off_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: 10,
                  //   scrollDirection: Axis.horizontal,
                  //   itemBuilder: (BuildContext context, int index) {
                  //
                  //     return Container(
                  //       margin: const EdgeInsets.symmetric(horizontal: 2),
                  //       child: Icon(
                  //         isCurrentTick(index, context)
                  //             ? Icons.radio_button_on_rounded
                  //             : Icons.radio_button_off_rounded,
                  //         color: Theme.of(context).colorScheme.primary,
                  //         size: 30,
                  //       ),
                  //     );
                  //   },
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: 'Select this song en go to play mode',
                    onPressed: () {
//                      widget.onSelectScreen('all-songs');
                    },
                  ),

                  // Column(
                  //   children: [
                  //     Slider(
                  //       divisions: 500,
                  //       min: 0,
                  //       max: 500,
                  //       // utiliser RhythmStore pour RÉCUPÉRER la valeur du rythme
                  //       value: bluetoothDelay.toDouble(),
                  //       onChanged: (double value) {
                  //         setState(() {
                  //           bluetoothDelay = value.toInt();
                  //
                  //           saveLatency();
                  //         });
                  //       },
                  //     ),
                  //     Text(bluetoothDelay.toString(),
                  //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool isCurrentTick(int indexStartingAtZero, BuildContext context) {
    // if(!RhythmStore.of(context).enable){
    //   return false;
    // } else{
    //   return indexStartingAtZero == currentIndexBullent;
    // }
    return true;
  }

  Future saveLatency() async {

    User? user = FirebaseAuth.instance.currentUser;

    if(user != null){
      // user unknow, we must create a new one
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'latency': bluetoothDelay
      });
    }else {
      // user already known, we don't need to update data to firestore database.
    }

    //return user;
  }
}
