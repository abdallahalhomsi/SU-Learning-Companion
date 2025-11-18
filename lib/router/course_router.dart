// This file makes up the components of the Course Router,
// which defines the navigation for the Course feature of the app.
// It includes routes for adding a course and viewing detailed course features.

import 'package:flutter/material.dart';
import '../features/courses/add_course_screen.dart';
import '../features/courses/detailed_course_features_screen.dart';

class CourseRouter {
  static const String addCourse = '/courses/add';
  static const String courseDetail = '/courses/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addCourse:
        return MaterialPageRoute(
          builder: (_) => const AddCourseScreen(),
        );

      case courseDetail:
        final courseId = settings.arguments as String?;
        if (courseId == null) {
          return _errorRoute('Course ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => DetailedCourseFeaturesScreen(courseId: courseId),
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

