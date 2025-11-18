// This file makes up the components of the Homeworks Router,
// which defines the navigation for the Homeworks feature of the app.
// It includes routes for listing homeworks and adding a new homework.


import 'package:flutter/material.dart';
import '../features/homeworks/homeworks_list_screen.dart';
import '../features/homeworks/homeworks_form_sheet.dart';

class HomeworksRouter {
  static Map<String, WidgetBuilder> routes = {
    '/homeworks': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return HomeworksListScreen(
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },
    '/addHomework': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return HomeworkFormScreen(
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },
  };
}