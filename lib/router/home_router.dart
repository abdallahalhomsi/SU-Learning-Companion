// This file makes up the components of the Home Router,
// which defines the navigation for the Home feature of the app.
// It includes the main route for the Home Screen.

import 'package:flutter/material.dart';
import '../features/Home/home_screen.dart';

class HomeRouter {
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
  };
}
