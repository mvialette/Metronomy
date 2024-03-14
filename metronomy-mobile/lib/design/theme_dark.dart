import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  primary: const Color.fromARGB(255, 255, 214, 1),
  onPrimary: Colors.black,
  secondary: Colors.white,
  tertiary: Colors.grey,
  seedColor: const Color.fromARGB(255, 212, 178, 1),
  background: const Color.fromARGB(255, 15, 15, 15),
  primaryContainer: Colors.black,
  onSurfaceVariant: Colors.black38,

  /*onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFE170),
  onPrimaryContainer: Color(0xFF221B00),
  secondary: Color(0xFFBA1A1A),//Color(0xFF675E40),
  onSecondary: Color(0xFFBA1A1A),//Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFBA1A1A),//Color(0xFFEFE2BC),
  onSecondaryContainer: Color(0xFFBA1A1A),//Color(0xFF211B04),
  tertiary: Color(0xFFBA1A1A),//Color(0xFF44664D),
  onTertiary: Color(0xFFBA1A1A),//Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFBA1A1A),//Color(0xFFC6ECCD),
  onTertiaryContainer: Color(0xFFBA1A1A),//Color(0xFF00210E),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFBA1A1A),//Color(0xFFFFFFFF),
  errorContainer: Color(0xFFBA1A1A),//Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFFBA1A1A),//Color(0xFF410002),
  outline: Color(0xFFBA1A1A),//Color(0xFF7C7767),

  onBackground: Color(0xFF1D1B16),
  surface: Color(0xFFBA1A1A),//Color(0xFFFFF8EF),
  onSurface: Color(0xFFBA1A1A),//Color(0xFF1D1B16),
  surfaceVariant: Color(0xFFBA1A1A),//Color(0xFFEAE2CF),
  onSurfaceVariant: Color(0xFFBA1A1A),//Color(0xFF4B4639),
  inverseSurface: Color(0xFFBA1A1A),//Color(0xFF33302A),
  onInverseSurface: Color(0xFFBA1A1A),//Color(0xFFF6F0E7),
  inversePrimary: Color(0xFFBA1A1A),//Color(0xFFE9C400),
  shadow: Color(0xFFBA1A1A),//Color(0xFF000000),
  surfaceTint: Color(0xFFBA1A1A),//Color(0xFF705D00),
  outlineVariant: Color(0xFFBA1A1A),//Color(0xFFCEC6B4),
  scrim: Color(0xFFBA1A1A),//Color(0xFF000000),*/


);

final darkTextTheme = TextTheme(
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
/*
    titleSmall: const TextStyle(
      fontFamily: 'StarsAndLoveBottomHeavy',
      fontSize: 16,
    ),
    */
  titleMedium: const TextStyle(
    fontFamily: 'StarsAndLoveBottomHeavy',
    fontSize: 26,
  ),
  titleLarge: const TextStyle(
    fontFamily: 'StarsAndLoveBottomHeavy',
    fontSize: 36,
  ),
  bodySmall: GoogleFonts.nunitoSans(
    fontWeight: FontWeight.normal,
    fontSize: 15,
  ),
  bodyMedium: GoogleFonts.nunitoSans(
    fontWeight: FontWeight.normal,
    fontSize: 20,
  ),
  bodyLarge: GoogleFonts.nunitoSans(
    fontWeight: FontWeight.normal,
    fontSize: 35,
  ),
);

final darkTheme = ThemeData.dark().copyWith(

  scaffoldBackgroundColor: darkColorScheme.background,

  colorScheme: darkColorScheme,

  textTheme: darkTextTheme,

  radioTheme: RadioThemeData(
    fillColor: MaterialStateColor.resolveWith((states) => darkColorScheme.primary), //<-- SEE HERE
  ),

  iconTheme: IconThemeData(color: darkColorScheme.primary),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      textStyle: darkTextTheme.bodyMedium,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)),
      minimumSize: Size(300, 50),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
  ),



  scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
      thickness: MaterialStateProperty.all(5),
      thumbColor: MaterialStateProperty.all(darkColorScheme.primary),
      radius: const Radius.circular(10),
      minThumbLength: 50,
  ),

  // Text theme section


);