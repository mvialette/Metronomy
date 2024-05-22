import 'package:metronomy/design/theme_dark.dart';
import 'package:metronomy/design/theme_light.dart';
import 'package:metronomy/providers/dark_mode_provider.dart';
import 'package:metronomy/providers/locale_provider.dart';
import 'package:metronomy/screen/splash_screen.dart';
import 'package:metronomy/store/rhythm_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// le point d'entrée de l'application devient asynchone afin que audioplayers charge correctement le son
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: RhythmProvider(child: MetronomyApp()),
    ),
  );
}

class MetronomyApp extends ConsumerWidget {
  const MetronomyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkMode = ref.watch(darkModeProvider);
    var localeCurrent = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (
        locale,
        supportedLocales,
      ) {
        return locale;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeCurrent,
      home: const SplashScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
