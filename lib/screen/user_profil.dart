
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Metronomy/l10n/l10n.dart';
import 'package:Metronomy/main.dart';
import 'package:Metronomy/providers/settings_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class UserProfilScreen extends ConsumerStatefulWidget {
  const UserProfilScreen({
    super.key,
  });

  @override
  ConsumerState<UserProfilScreen> createState() => _UserProfilScreenState();
}

class _UserProfilScreenState extends ConsumerState<UserProfilScreen> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;
  late String languageCode;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    debuggingMode = ref.read(allSettingsProvider).debuggingMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    languageCode = locale.languageCode;

    final flag = L10n.getFlag(locale.languageCode);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Text(AppLocalizations.of(context)!.usernameLabel),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'prenom.nom@email.com',
                  //style: Theme.of(context).textTheme.headlineMedium,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.languageLabel),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: L10n.all.length,
              itemBuilder: (context, index) {
                //return Text(L10n.all[index].languageCode);
                return SizedBox(
                  height: 50,
                  child: Center(
                      child: Row(
                        children: [
                          Radio(
                            value: L10n.all[index].languageCode,
                            groupValue: languageCode,
                            onChanged: (String? value) {
                              setState(() {
                                languageCode = value!;
                                MetronomyApp.setLocale(context, Locale(languageCode));
                              });
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
                              L10n.all[index].languageCode == L10n.all[0].languageCode
                                  ? AppLocalizations.of(context)!.localEn
                                  : AppLocalizations.of(context)!.localFr),
                        ],
                      )),
                );
              },
            ),
          ]),
        ),
      ],
    );
  }
}
