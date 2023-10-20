import 'package:flutter/material.dart';
import 'color_schemes.g.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: lightColorScheme.background,
  colorScheme: lightColorScheme,
  textTheme: TextTheme(
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
      fontWeight: FontWeight.bold,
      fontSize: 25,

    ),

    bodyLarge: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 35,
      
  ),

  ),
);

final darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: darkColorScheme.background,
  colorScheme: darkColorScheme,
  textTheme: TextTheme(
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
      fontWeight: FontWeight.bold,
      fontSize: 25,

    ),

    bodyLarge: GoogleFonts.acme(
      fontWeight: FontWeight.bold,
      fontSize: 35,

    ),
  ),
);