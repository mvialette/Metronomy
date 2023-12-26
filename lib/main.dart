import 'package:Metronomy/screen/home_screen.dart';
import 'package:Metronomy/store/rhythm_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Metronomy/main.i18n.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  primary: const Color.fromARGB(255, 226, 126, 20),
  seedColor: const Color.fromARGB(255, 226, 126, 20),
  background: const Color.fromARGB(158, 189, 183, 171),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.acmeTextTheme().copyWith(
    titleSmall: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    titleMedium: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
    titleLarge: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 35,
    ),
  ),
);

// le point d'entrée de l'application devient asynchone afin que audioplayers charge correctement le son
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
        child: const RhythmProvider(
            child: MetronomyApp()
        ),
    ),
  );
}

class MetronomyApp extends StatelessWidget {

  const MetronomyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

   return MaterialApp(
     localizationsDelegates: [
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
      supportedLocales: [
        const Locale('en', "US"),
        const Locale('fr', "FR"),
      ],
      //title: I18n(child: Text(appbarTitle.i18n)),
      home: I18n(
        // Usually you should not provide an initialLocale,
        // and just let it use the system locale.
        // initialLocale: Locale("pt", "BR"),
        //
        //child: Text(appbarTitle.i18n),
        initialLocale: Locale("fr", "FR"),
        //initialLocale: Locale("en", "US"),
        child: const HomeScreen(),
      ),
      theme: theme,
    );
  }
}