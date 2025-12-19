import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/providers/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/theme.dart';

class SUApp extends StatelessWidget {
  const SUApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'SU Learning Companion',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: suLightThemeAndFonts,
      darkTheme: suDarkThemeAndFonts,
      themeMode: themeProvider.themeMode,
    );
  }
}
