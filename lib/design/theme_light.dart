import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF705D00),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFE170),
  onPrimaryContainer: Color(0xFF221B00),
  secondary: Color(0xFF675E40),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFEFE2BC),
  onSecondaryContainer: Color(0xFF211B04),
  tertiary: Color(0xFF44664D),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC6ECCD),
  onTertiaryContainer: Color(0xFF00210E),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  outline: Color(0xFF7C7767),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF1D1B16),
  surface: Color(0xFFFFF8EF),
  onSurface: Color(0xFF1D1B16),
  surfaceVariant: Color(0xFFEAE2CF),
  onSurfaceVariant: Color(0xFF4B4639),
  inverseSurface: Color(0xFF33302A),
  onInverseSurface: Color(0xFFF6F0E7),
  inversePrimary: Color(0xFFE9C400),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF705D00),
  outlineVariant: Color(0xFFCEC6B4),
  scrim: Color(0xFF000000),
);

final lightTheme = ThemeData.light().copyWith(
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