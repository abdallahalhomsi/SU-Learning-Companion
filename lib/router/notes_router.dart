import 'package:go_router/go_router.dart';
import '../features/notes/home_screen.dart';

final notesRoutes = [
  GoRoute(path: '/notes', builder: (_, __) => const NotesScreen()),
];

/// Routes for Notes feature.
/// - List and editor routes later.