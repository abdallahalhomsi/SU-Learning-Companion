// lib/router/app_router.dart
//
// GoRouter navigation for the whole app with AUTH GUARD.
// - Logged-out users can only access auth screens
// - Logged-in users can only access main app screens

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth
import 'package:su_learning_companion/features/Authentication/welcome.dart';
import 'package:su_learning_companion/features/Authentication/sign_in.dart';
import 'package:su_learning_companion/features/Authentication/sign_up1.dart';
import 'package:su_learning_companion/features/Authentication/sign_up2.dart';

// Core
import 'package:su_learning_companion/features/Home/home_screen.dart';
import 'package:su_learning_companion/features/courses/add_course_screen.dart';
import 'package:su_learning_companion/features/courses/detailed_course_features_screen.dart';
import 'package:su_learning_companion/features/calendar/calendar_screen.dart';
import 'package:su_learning_companion/features/Profile/profile_screen.dart';
import 'package:su_learning_companion/features/notes/notes_list_screen.dart';

// Exams & Homeworks
import 'package:su_learning_companion/features/exams/exams_list_screen.dart';
import 'package:su_learning_companion/features/exams/exams_form_sheet.dart';
import 'package:su_learning_companion/features/homeworks/homeworks_list_screen.dart';
import 'package:su_learning_companion/features/homeworks/homeworks_form_sheet.dart';

// Resources
import 'package:su_learning_companion/features/resources/resources_list_screen.dart';
import 'package:su_learning_companion/features/resources/add_resource_screen.dart';
import 'package:su_learning_companion/features/resources/resource_details_screen.dart';

// Flashcards
import 'package:su_learning_companion/features/flashcards/flashcards_topics.dart';
import 'package:su_learning_companion/features/flashcards/flashcards_questions_screen.dart';
import 'package:su_learning_companion/features/flashcards/flashcards_solution.dart';
import 'package:su_learning_companion/features/flashcards/flashcard_form_sheet_group.dart';
import 'package:su_learning_companion/features/flashcards/flashcard_form_sheet_question.dart';

class AppRouter {
  // Listen to Firebase auth state changes
  static final _authRefresh =
  GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());

  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: _authRefresh,

    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final location = state.matchedLocation;

      // Public routes (no authentication required)
      final isPublicRoute = location == '/welcome' ||
          location == '/login' ||
          location == '/signup' ||
          location == '/signup_2';

      //  Not logged in → block protected routes
      if (user == null && !isPublicRoute) {
        return '/login';
      }

      //  Logged in → block auth screens
      if (user != null && isPublicRoute) {
        return '/home';
      }

      return null;
    },

    routes: [
      // =====================
      // AUTH / WELCOME
      // =====================
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
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

      // =====================
      // HOME
      // =====================
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
        builder: (context, state) => const ProfileScreen(),
      ),

      // EXAMS
      GoRoute(
        path: '/courses/:courseId/exams',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return ExamsListScreen(courseId: courseId, courseName: courseName);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/exams/add',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return ExamFormScreen(courseId: courseId, courseName: courseName);
        },
      ),

      // NOTES
      GoRoute(
        path: '/courses/:courseId/notes',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return NotesListScreen(courseId: courseId, courseName: courseName);
        },
      ),

      // HOMEWORKS
      GoRoute(
        path: '/courses/:courseId/homeworks',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return HomeworksListScreen(courseId: courseId, courseName: courseName);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/homeworks/add',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return HomeworkFormScreen(courseId: courseId, courseName: courseName);
        },
      ),

      // RESOURCES
      GoRoute(
        path: '/courses/:courseId/resources',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return ResourcesListScreen(courseId: courseId, courseName: courseName);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/resources/add',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return AddResourceScreen(courseId: courseId, courseName: courseName);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/resources/details',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;

          if (extra == null || extra['resource'] == null) {
            return const Scaffold(
              body: Center(child: Text('Missing resource data')),
            );
          }

          return ResourceDetailsScreen(
            resource: extra['resource'],
            courseId: courseId,
            courseName: extra['courseName'] ?? 'Course',
          );
        },
      ),

      // FLASHCARDS
      GoRoute(
        path: '/courses/:courseId/flashcards',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final courseName = extra?['courseName'] ?? 'Course';
          return FlashcardsTopicsScreen(courseId: courseId, courseName: courseName);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/flashcards/:groupId/questions',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final groupId = state.pathParameters['groupId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return FlashcardsQuestionsScreen(
            courseId: courseId,
            courseName: extra?['courseName'] ?? 'Course',
            groupId: groupId,
            groupTitle: extra?['groupTitle'] ?? 'Group',
          );
        },
      ),
      GoRoute(
        path: '/flashcards/solution',
        builder: (context, state) {
          final data = state.extra as Map<String, String>?;
          return FlashcardSolutionScreen(
            cardTitle: data?['title'] ?? 'Card',
            solutionText: data?['solution'] ?? 'Solution',
          );
        },
      ),

      // 1. Add Flashcard Group
      GoRoute(
        path: '/flashcards/groups/add',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FlashcardFormSheetGroup(
            courseId: extra?['courseId'] ?? '',
          );
        },
      ),

      // 2. Add Flashcard Question
      GoRoute(
        path: '/flashcards/create',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FlashcardFormSheetQuestion(
            groupId: extra?['groupId'] ?? '',
            courseId: extra?['courseId'] ?? '',
          );
        },
      ),
    ],
  );
}

/// Listens to a stream and notifies GoRouter to re-evaluate redirects
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}