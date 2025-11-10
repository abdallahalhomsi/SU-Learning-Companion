import 'package:flutter/material.dart';
import '../features/calendar/calendar_screen.dart';

class CalendarRouter {
  static const String calendar = '/calendar';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case calendar:
        return MaterialPageRoute(
          builder: (_) => const CalendarScreen(),
        );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}