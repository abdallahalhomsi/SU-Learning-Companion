import 'package:go_router/go_router.dart';
import 'dashboard_router.dart';
import 'courses_router.dart';
import 'tasks_router.dart';
import 'flashcards_router.dart';
import 'notes_router.dart';


final appRouter = GoRouter(routes: [
  ...dashboardRoutes,
  ...coursesRoutes,
  ...tasksRoutes,
  ...flashcardsRoutes,
  ...notesRoutes,
]);

/// Central router.
/// - Combines feature route lists (dashboard, courses, tasks, ...).
/// - Single source used by MaterialApp.router.
/// Future: add route guards (auth) and deep links.