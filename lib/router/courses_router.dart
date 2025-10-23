import 'package:go_router/go_router.dart';
import '../features/courses/courses_screen.dart';

final coursesRoutes = [
  GoRoute(path: '/courses', builder: (_, __) => const CoursesScreen()),
];


/// Routes for Courses feature.
/// - List page now; later add '/courses/:id' detail.