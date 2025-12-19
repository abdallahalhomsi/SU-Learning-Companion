import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'common/di/locator.dart';
import 'router/app_router.dart';
import 'firebase_options.dart';

import 'common/providers/theme_provider.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ...buildProviders(), // your repos + AuthProvider
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..loadTheme(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: suLightThemeAndFonts,
      darkTheme: suDarkThemeAndFonts,
      themeMode: themeProvider.themeMode,
    );
  }
}
