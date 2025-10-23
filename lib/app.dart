import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'router/app_router.dart';

class SUApp extends StatelessWidget {
  const SUApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SU Learning Companion',
      theme: suLightTheme,
      routerConfig: appRouter,
    );
  }
}


/// Root widget (MaterialApp.router).
/// - Applies Theme.
/// - Uses the central GoRouter config.
/// Future: may add locale, theme switching, error screens.