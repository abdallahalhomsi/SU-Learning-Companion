// lib/router/flashcards_router.dart
//
// GoRouter routes for Flashcards feature.
// Uses course-scoped + group-scoped paths.
// - /courses/:courseId/flashcards
// - /courses/:courseId/flashcards/:groupId/questions
// Global utility routes:
// - /flashcards/solution
// - /flashcards/groups/add
// - /flashcards/create

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:su_learning_companion/features/flashcards/flashcards_topics.dart';
import 'package:su_learning_companion/features/flashcards/flashcards_questions_screen.dart';
import 'package:su_learning_companion/features/flashcards/flashcards_solution.dart';
import 'package:su_learning_companion/features/flashcards/flashcard_form_sheet_group.dart';
import 'package:su_learning_companion/features/flashcards/flashcard_form_sheet_question.dart';

class FlashcardsRouter {
  // Course-scoped routes
  static const String topics = '/courses/:courseId/flashcards';
  static const String questions =
      '/courses/:courseId/flashcards/:groupId/questions';

  // Global routes (no courseId needed)
  static const String solution = '/flashcards/solution';
  static const String groupsAdd = '/flashcards/groups/add';
  static const String create = '/flashcards/create';

  static final List<GoRoute> routes = [
    // TOPICS (Groups list) for a COURSE
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

    // QUESTIONS (Cards list) for a GROUP inside a COURSE
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

    // SOLUTION (Global)
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

    // ADD GROUP (Global form sheet)
    GoRoute(
      path: groupsAdd,
      builder: (context, state) => const FlashcardFormSheetGroup(),
    ),

    // CREATE CARD (Global form sheet)
    GoRoute(
      path: create,
      builder: (context, state) => const FlashcardFormSheetQuestion(),
    ),
  ];
}
