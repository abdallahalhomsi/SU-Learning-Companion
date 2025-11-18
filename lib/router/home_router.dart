import 'package:flutter/material.dart';
import '../features/Home/home_screen.dart';

class HomeRouter {
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
  };
}
