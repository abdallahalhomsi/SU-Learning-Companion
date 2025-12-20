// lib/router/flashcards_router.dart
//
// GoRouter routes for Flashcards feature.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/flashcards/flashcards_topics.dart';
import '../features/flashcards/flashcards_questions_screen.dart';
import '../features/flashcards/flashcards_solution.dart';
import '../features/flashcards/flashcard_form_sheet_group.dart';
import '../features/flashcards/flashcard_form_sheet_question.dart';

class FlashcardsRouter {
  static const String topics = '/courses/:courseId/flashcards';
  static const String questions =
      '/courses/:courseId/flashcards/:groupId/questions';

  static const String solution = '/flashcards/solution';
  static const String groupsAdd = '/flashcards/groups/add';
  static const String create = '/flashcards/create';

  static final List<GoRoute> routes = [
    GoRoute(
      path: topics,
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;

        final extra = state.extra as Map<String, dynamic>?;
        final courseName = extra?['courseName'] as String? ?? 'Course';

        return FlashcardsTopicsScreen(
          courseId: courseId,
          courseName: courseName,
        );
      },
    ),

    GoRoute(
      path: questions,
      builder: (context, state) {
        final courseId = state.pathParameters['courseId']!;
        final groupId = state.pathParameters['groupId']!;

        final extra = state.extra as Map<String, dynamic>?;
        final groupTitle = extra?['groupTitle'] as String? ?? 'Group';
        final courseName = extra?['courseName'] as String? ?? 'Course';

        return FlashcardsQuestionsScreen(
          courseId: courseId,
          courseName: courseName,
          groupId: groupId,
          groupTitle: groupTitle,
        );
      },
    ),

    GoRoute(
      path: solution,
      builder: (context, state) {
        final data = state.extra as Map<String, String>?;

        final cardTitle = data?['title'] ?? 'Card';
        final solutionText = data?['solution'] ?? 'Solution text coming soon';

        return FlashcardSolutionScreen(
          cardTitle: cardTitle,
          solutionText: solutionText,
        );
      },
    ),

    GoRoute(
      path: groupsAdd,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final courseId = extra?['courseId'] as String? ?? '';

        return FlashcardFormSheetGroup(
          courseId: courseId,
        );
      },
    ),

    GoRoute(
      path: create,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final courseId = extra?['courseId'] as String? ?? '';
        final groupId = extra?['groupId'] as String? ?? '';

        return FlashcardFormSheetQuestion(
          courseId: courseId,
          groupId: groupId,
        );
      },
    ),
  ];
}