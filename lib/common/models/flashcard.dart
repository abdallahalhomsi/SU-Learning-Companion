// lib/common/models/flashcard_models.dart

class FlashcardGroup {
  final String id;
  final String courseId;
  final String title;
  final String difficulty; // Easy/Medium/Hard
  final DateTime createdAt;

  FlashcardGroup({
    required this.id,
    required this.courseId,
    required this.title,
    required this.difficulty,
    required this.createdAt,
  });
}

class Flashcard {
  final String id;
  final String courseId;
  final String groupId;
  final String question;
  final String solution;
  final String difficulty; // Easy/Medium/Hard
  final DateTime createdAt;

  Flashcard({
    required this.id,
    required this.courseId,
    required this.groupId,
    required this.question,
    required this.solution,
    required this.difficulty,
    required this.createdAt,
  });
}
