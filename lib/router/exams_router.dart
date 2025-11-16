import 'package:flutter/material.dart';
import '../features/exams/exams_list_screen.dart';
import '../features/exams/exams_form_sheet.dart';

class ExamsRouter {
  static Map<String, WidgetBuilder> routes = {
    '/exams': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      return ExamsListScreen(
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },

    '/addExam': (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      return ExamFormScreen(
        courseId: args['courseId'],
        courseName: args['courseName'],
      );
    },
  };
}