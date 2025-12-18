import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';
import 'router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/providers/theme_provider.dart';
import 'common/repos/flashcards_repo.dart';
import 'common/repos/firestore_flashcards_repo.dart';

class SUApp extends StatelessWidget {
  const SUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadTheme(), // Load saved theme on startup
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'SU Learning Companion',
            theme: suLightThemeAndFonts,
            darkTheme: suDarkThemeAndFonts,
            themeMode: themeProvider.themeMode, // Use saved theme preference
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// Root widget (MaterialApp.router).
/// - Applies Theme with providers for light/dark mode switching.
/// - Uses the central GoRouter config.
/// - Loads saved theme preference from SharedPreferences on startup.