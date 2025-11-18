import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/features/Authentication/sign_in.dart';
import 'package:su_learning_companion/features/Authentication/sign_up1.dart';
import 'package:su_learning_companion/features/Authentication/sign_up2.dart';
import 'package:su_learning_companion/features/Authentication/welcome.dart';
import '../features/courses/temp_courses_screen.dart';
import '../features/courses/add_course_screen.dart';
import '../features/courses/detailed_course_features_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../common/widgets/app_scaffold.dart';
import '../features/exams/exams_list_screen.dart';
import '../features/exams/exams_form_sheet.dart';
import '../features/homeworks/homeworks_list_screen.dart';
import '../features/homeworks/homeworks_form_sheet.dart';
import '../features/resources/resources_list_screen.dart';
import '../features/resources/add_resource_screen.dart';
import '../features/resources/resource_details_screen.dart';
import '../features/flashcards/flashcard_form_sheet_group.dart';
import '../features/flashcards/flashcard_form_sheet_question.dart';
import '../features/Home/home_screen.dart';
import '../features/flashcards/flashcards_questions_screen.dart';
import '../features/flashcards/flashcards_solution.dart';
import '../features/flashcards/flashcards_topics.dart';
import '../features/Profile/profile_screen.dart';
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/welcome',
    routes: [
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
      GoRoute(
        path: '/',
        builder: (context, state) => const CoursesScreen(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/courses/add',
        builder: (context, state) => const AddCourseScreen(),
      ),
      GoRoute(
        path: '/courses/detail/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'];
          if (courseId == null) {
            return const CoursesScreen();
          }
          return DetailedCourseFeaturesScreen(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
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
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // FLASHCARDS ROUTES
      GoRoute(
        path: '/flashcards',
        builder: (context, state) => const FlashcardsTopicsScreen(),
      ),
      GoRoute(
        path: '/flashcards/questions',
        builder: (context, state) {
          // we pass group title via extra from topics screen
          final groupTitle = state.extra as String? ?? 'Chapter X';
          return FlashcardsQuestionsScreen(groupTitle: groupTitle);
        },
      ),
      GoRoute(
        path: '/flashcards/solution',
        builder: (context, state) {
          // we pass title + solution via extra map from questions screen
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
