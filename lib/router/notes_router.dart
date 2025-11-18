// This file makes up the components of the Notes Router,
// which defines the navigation for the Notes feature of the app.
// It includes the main route for the Notes List Screen.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/notes/notes_list_screen.dart';

class NotesRouter {
  static const String notes = '/courses/:courseId/notes';

  static final List<GoRoute> routes = [
    GoRoute(
      path: notes,
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        final extra = state.extra as Map<String, dynamic>?;

        final courseName = extra?['courseName'] ?? 'Course';

        return NotesListScreen(
          courseId: courseId,
          courseName: courseName,
        );
      },
    ),
  ];
}
