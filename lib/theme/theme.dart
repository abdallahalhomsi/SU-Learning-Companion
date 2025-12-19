// lib/theme/theme.dart
import 'package:flutter/material.dart';
import '../common/utils/app_colors.dart';

/// One single source of truth for themes.
/// DO NOT define suLightThemeAndFonts / suDarkThemeAndFonts anywhere else.
ThemeData get suLightThemeAndFonts => _buildLightTheme();
ThemeData get suDarkThemeAndFonts => _buildDarkTheme();

ThemeData _buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.textOnPrimary,
      iconTheme: IconThemeData(color: AppColors.textOnPrimary),
    ),

    // ✅ Cursor/selection for visibility
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryBlue,
      selectionColor: AppColors.primaryBlue.withValues(alpha: 0.25),
      selectionHandleColor: AppColors.primaryBlue,
    ),

    // ✅ Input defaults
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputGrey,
      hintStyle: const TextStyle(color: Colors.black54),
      labelStyle: const TextStyle(color: Colors.black87),
      helperStyle: const TextStyle(color: Colors.black54),
      errorStyle: const TextStyle(color: Colors.red),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.inputGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.inputGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      ),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textPrimary),
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      titleMedium: TextStyle(color: AppColors.textPrimary),
      titleLarge: TextStyle(color: AppColors.textPrimary),
    ),
  );
}

ThemeData _buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.dark,
  );

  // Dark surfaces (readable)
  const darkScaffold = Color(0xFF0F172A); // slate-900
  const darkCard = Color(0xFF111C33); // custom dark card
  const darkInput = Color(0xFF1E2A44); // input background for dark mode
  const onDark = Colors.white;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: darkScaffold,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.textOnPrimary,
      iconTheme: IconThemeData(color: AppColors.textOnPrimary),
    ),

    // ✅ Cursor/selection for visibility in dark mode
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white.withValues(alpha: 0.25),
      selectionHandleColor: Colors.white,
    ),

    // ✅ FIX: ThemeData.cardTheme expects CardThemeData (not CardTheme)
    cardTheme: const CardThemeData(
      color: darkCard,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkInput,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.70)),
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
      helperStyle: TextStyle(color: Colors.white.withValues(alpha: 0.70)),
      errorStyle: const TextStyle(color: Colors.redAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
      ),
    ),

    // ✅ Default text colors in dark mode
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: onDark),
      bodyLarge: TextStyle(color: onDark),
      titleMedium: TextStyle(color: onDark),
      titleLarge: TextStyle(color: onDark),
    ),
  );
}
