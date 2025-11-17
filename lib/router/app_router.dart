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
    ],
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Profile Screen - Coming Soon'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: const Color(0xFF003366),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
            // Already on profile
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}