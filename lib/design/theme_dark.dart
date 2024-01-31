import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  primary: const Color.fromARGB(255, 255, 214, 1),
  seedColor: const Color.fromARGB(255, 212, 178, 1),
  background: const Color.fromARGB(255, 15, 15, 15),
);

final darkTheme = ThemeData.dark().copyWith(

  scaffoldBackgroundColor: darkColorScheme.background,

  colorScheme: darkColorScheme,

  iconTheme: IconThemeData(color: darkColorScheme.primary),

  // Text theme section
  textTheme: TextTheme(
    /*
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
     */
    titleSmall: const TextStyle(
      fontFamily: 'StarsAndLoveBottomHeavy',
      fontSize: 16,
    ),
    titleMedium: const TextStyle(
      fontFamily: 'StarsAndLoveBottomHeavy',
      fontSize: 26,
    ),
    titleLarge: const TextStyle(
      fontFamily: 'StarsAndLoveBottomHeavy',
      fontSize: 36,
    ),
    bodySmall: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
    bodyMedium: GoogleFonts.acme(
      fontWeight: FontWeight.normal,
      fontSize: 20,
    ),
    bodyLarge: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 35,
    ),
  ),
);