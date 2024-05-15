import 'package:metronomy/providers/dark_mode_provider.dart';
import 'package:metronomy/providers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:input_quantity/input_quantity.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool firstSongDifferent;
  late int startingBarsNumber;
  late bool debuggingMode;
  late bool advancedMode;

  @override
  void initState() {
    firstSongDifferent = ref.read(allSettingsProvider).firstSongDifferent;
    startingBarsNumber = ref.read(allSettingsProvider).startingBarsNumber;
    debuggingMode = ref.read(allSettingsProvider).debuggingMode;
    advancedMode = ref.read(allSettingsProvider).advanceMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var darkMode = ref.watch(darkModeProvider);

    return Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.settings,
                  color: Theme.of(context).colorScheme.primary, size: 80)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(AppLocalizations.of(context)!.settings,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary))
            ]),
            const SizedBox(height: 60),
            Row(children: [
              Text(AppLocalizations.of(context)!.firstSongDifferent),
              Expanded(child: Container()),
              Switch(
                  value: firstSongDifferent,
                  onChanged: (check) {
                    setState(() {
                      firstSongDifferent = check;
                    });
                    ref.read(allSettingsProvider.notifier).updateSettings(
                        firstSongDifferent, debuggingMode, advancedMode);
                  })
            ]),
            const SizedBox(height: 30),
            Row(children: [
              Text(AppLocalizations.of(context)!.debugMode),
              Expanded(child: Container()),
              Switch(
                  value: debuggingMode,
                  onChanged: (check) {
                    setState(() {
                      debuggingMode = check;
                    });
                    ref.read(allSettingsProvider.notifier).updateSettings(
                        firstSongDifferent, debuggingMode, advancedMode);
                  })
            ]),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.advancedMode),
                Expanded(child: Container()),
                Switch(
                  value: advancedMode,
                  onChanged: (check) {
                    setState(() {
                      advancedMode = check;
                    });
                    ref.read(allSettingsProvider.notifier).updateSettings(
                        firstSongDifferent, debuggingMode, advancedMode);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [
              Text(AppLocalizations.of(context)!.startingCountdownBarsNumber),
              Expanded(child: Container()),
              InputQty.int(
                  maxVal: 5,
                  initVal: startingBarsNumber,
                  minVal: 0,
                  steps: 1,
                  onQtyChanged: (val) {
                    startingBarsNumber = val;
                    ref
                        .read(allSettingsProvider.notifier)
                        .updateStartingBarsNumber(startingBarsNumber);
                  },
                  decoration: QtyDecorationProps(
                      qtyStyle: QtyStyle.btnOnRight,
                      width: 5,
                      btnColor: Theme.of(context).colorScheme.primary,
                      isBordered: false,
                      borderShape: BorderShapeBtn.square)),
            ]),
            const SizedBox(height: 30),
            Row(children: [
              Text(AppLocalizations.of(context)!.databaseVersion)
            ]),
            Row(children: [
              Text('version de la bdd', // ${kSelectedCollection}',
                  //style: Theme.of(context).textTheme.headlineMedium,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.tertiary))
            ])
          ]))
    ]);
  }
}
