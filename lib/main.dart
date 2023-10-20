
import 'package:Metronomy/design/theme.dart';
import 'package:Metronomy/screen/music_player_screen.dart';
import 'package:Metronomy/screen/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(
    const ProviderScope(child: MetronomyApp()),
  );
}

class MetronomyApp extends StatelessWidget {

  const MetronomyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metronomy App',
      theme: lightTheme,
      darkTheme: darkTheme,
      home:   SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  primary: const Color.fromARGB(255, 226, 126, 20),
  seedColor: const Color.fromARGB(255, 226, 126, 20),
  background: const Color.fromARGB(158, 189, 183, 171),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
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
);*/