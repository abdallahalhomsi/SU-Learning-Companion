// lib/router/home_router.dart
//
// Legacy (non-GoRouter) route map.
// Keep only if some older code still uses Navigator routes.

import 'package:flutter/material.dart';
import 'package:su_learning_companion/features/Home/home_screen.dart';

class HomeRouter {
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
  };
}
