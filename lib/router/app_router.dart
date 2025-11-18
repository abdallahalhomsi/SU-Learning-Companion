// This file makes up the components of the App Router,
// which defines the navigation structure of the app using GoRouter.
// It includes routes for authentication, home, courses, calendar, profile,
// exams, homeworks, resources, and flashcards.


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth
import 'package:su_learning_companion/features/Authentication/sign_in.dart';
import 'package:su_learning_companion/features/Authentication/sign_up1.dart';
import 'package:su_learning_companion/features/Authentication/sign_up2.dart';
import 'package:su_learning_companion/features/Authentication/welcome.dart';

// Core features
import '../features/Home/home_screen.dart';
import '../features/courses/add_course_screen.dart';
import '../features/courses/detailed_course_features_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/Profile/profile_screen.dart';
import '../features/notes/notes_list_screen.dart';

// Exams & Homeworks
import '../features/exams/exams_list_screen.dart';
import '../features/exams/exams_form_sheet.dart';
import '../features/homeworks/homeworks_list_screen.dart';
import '../features/homeworks/homeworks_form_sheet.dart';

// Resources
import '../features/resources/resources_list_screen.dart';
import '../features/resources/add_resource_screen.dart';
import '../features/resources/resource_details_screen.dart';

// Flashcards
import '../features/flashcards/flashcard_form_sheet_group.dart';
import '../features/flashcards/flashcard_form_sheet_question.dart';
import '../features/flashcards/flashcards_questions_screen.dart';
import '../features/flashcards/flashcards_solution.dart';
import '../features/flashcards/flashcards_topics.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      // WELCOME / AUTH
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 600),
            child: const SignInScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpStep1Screen(),
      ),
      GoRoute(
        path: '/signup_2',
        builder: (context, state) => const SignUpStep2Screen(),
      ),

      // HOME
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // COURSE DETAIL 
      GoRoute(
        path: '/courses/detail/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          return DetailedCourseFeaturesScreen(courseId: courseId);
        },
      ),

      // ADD COURSE
      GoRoute(
        path: '/courses/add',
        builder: (context, state) => const AddCourseScreen(),
      ),

      // CALENDAR
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),

      // PROFILE
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // EXAMS
      GoRoute(
        path: '/courses/:courseId/exams',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return ExamsListScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),
      GoRoute(
        path: '/courses/:courseId/exams/add',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return ExamFormScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),

      // NOTES
      GoRoute(
        path: '/courses/:courseId/notes',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return NotesListScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),


      // HOMEWORKS
      GoRoute(
        path: '/courses/:courseId/homeworks',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return HomeworksListScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),
      GoRoute(
        path: '/courses/:courseId/homeworks/add',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return HomeworkFormScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),

      // RESOURCES
      GoRoute(
        path: '/courses/:courseId/resources',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return ResourcesListScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),
      GoRoute(
        path: '/courses/:courseId/resources/add',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          final courseName = extra?['courseName'] as String? ?? 'Course';

          return AddResourceScreen(
            courseId: courseId,
            courseName: courseName,
          );
        },
      ),
      GoRoute(
        path: '/courses/:courseId/resources/details',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          return ResourceDetailsScreen(
            resource: extra!['resource'],
            courseId: courseId,
            courseName: extra['courseName'] ?? 'Course',
          );
        },
      ),

      // FLASHCARDS
      GoRoute(
        path: '/flashcards',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          return FlashcardsTopicsScreen(
            courseId: extra?['courseId'],
            courseName: extra?['courseName'] ?? 'Course Name',
          );
        },
      ),
      GoRoute(
        path: '/flashcards/questions',
        builder: (context, state) {
          final groupTitle = state.extra as String? ?? 'Chapter X';
          return FlashcardsQuestionsScreen(groupTitle: groupTitle);
        },
      ),
      GoRoute(
        path: '/flashcards/solution',
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
        path: '/flashcards/groups/add',
        builder: (context, state) => const FlashcardFormSheetGroup(),
      ),
      GoRoute(
        path: '/flashcards/create',
        builder: (context, state) => const FlashcardFormSheetQuestion(),
      ),
    ],
  );
}
