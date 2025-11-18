
// This file makes up the components of the Notes Router,
// which defines the navigation for the Flashcards feature of the app.
// It includes routes for listing flashcard topics, viewing questions and solutions,
// and adding new flashcard groups and questions.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/flashcards/flashcards_topics.dart';
import '../features/flashcards/flashcards_questions_screen.dart';
import '../features/flashcards/flashcards_solution.dart';
import '../features/flashcards/flashcard_form_sheet_group.dart';
import '../features/flashcards/flashcard_form_sheet_question.dart';

class FlashcardsRouter {

  static const String base = '/flashcards';
  static const String questions = '/flashcards/questions';
  static const String solution = '/flashcards/solution';
  static const String groupsAdd = '/flashcards/groups/add';
  static const String create = '/flashcards/create';

  static final List<GoRoute> routes = [

    GoRoute(
      path: base,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return FlashcardsTopicsScreen(
          courseId: extra?['courseId'],
          courseName: extra?['courseName'] ?? 'Course Name',
        );
      },
    ),

  
    GoRoute(
      path: questions,
      builder: (context, state) {
        final groupTitle = state.extra as String? ?? 'Chapter X';
        return FlashcardsQuestionsScreen(groupTitle: groupTitle);
      },
    ),

   
    GoRoute(
      path: solution,
      builder: (context, state) {
        final data = state.extra as Map<String, String>?;

        final cardTitle = data?['title'] ?? 'Card';
        final solutionText =
            data?['solution'] ?? 'Solution text coming soon';

        return FlashcardSolutionScreen(
          cardTitle: cardTitle,
          solutionText: solutionText,
        );
      },
    ),

  
    GoRoute(
      path: groupsAdd,
      builder: (context, state) => const FlashcardFormSheetGroup(),
    ),

    
    GoRoute(
      path: create,
      builder: (context, state) => const FlashcardFormSheetQuestion(),
    ),
  ];
}
