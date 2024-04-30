import 'package:metronomy/l10n/l10n.dart';
import 'package:metronomy/providers/dark_mode_provider.dart';
import 'package:metronomy/providers/locale_provider.dart';
import 'package:metronomy/providers/settings_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    var darkMode = ref.watch(darkModeProvider);
    final locale = Localizations.localeOf(context);
    languageCode = locale.languageCode;

    User? user = FirebaseAuth.instance.currentUser;
    final displayName = user != null ? user.displayName : "toto";
    final userEmail = user != null ? user.email : "toto";
    final userImage = user?.photoURL;

    return Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(AppLocalizations.of(context)!.myAccount,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (userImage == null)
                Icon(Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary, size: 80)
              else
                CircleAvatar(
                    radius: 50.0,
                    backgroundImage: Image.network(userImage).image,
                    backgroundColor: Colors.transparent),
            ]),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.person,
                  color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 10),
              Text(
                displayName.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary, fontSize: 20),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.email, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 10),
              Text(
                userEmail.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary, fontSize: 20),
              )
            ]),
            const SizedBox(height: 60),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                AppLocalizations.of(context)!.languageLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              )
            ]),
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
              const SizedBox(width: 10),
              Switch(
                  activeColor: Theme.of(context).colorScheme.primaryContainer,
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  value: darkMode,
                  onChanged: (val) {
                    ref.read(darkModeProvider.notifier).toggle();
                  })
            ])
          ]))
    ]);
  }
}
