import 'package:go_router/go_router.dart';
import '../features/tasks/tasks_screen.dart';

final tasksRoutes = [
  GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen()),
];


/// Routes for Tasks feature.
/// - List page now; later add '/tasks/new' and '/tasks/:id/edit'.