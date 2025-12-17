import 'package:flutter/material.dart';

/// Light theme for the app
final suLightThemeAndFonts = ThemeData(
  fontFamily: 'AppFont',
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF005BBB),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF003366),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
);

/// Dark theme for the app
final suDarkThemeAndFonts = ThemeData(
  fontFamily: 'AppFont',
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF005BBB),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
);

/// App theme (colors, typography).
/// Frontend-only.
/// Now includes both light and dark themes.