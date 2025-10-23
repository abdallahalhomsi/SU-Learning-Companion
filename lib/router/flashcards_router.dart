import 'package:go_router/go_router.dart';
import '../features/flashcards/flashcards_screen.dart';

final flashcardsRoutes = [
  GoRoute(path: '/flashcards', builder: (_, __) => const FlashcardsScreen()),
];

/// Routes for Flashcards feature.
/// - List/study routes later: '/flashcards', '/flashcards/:deckId/study'.