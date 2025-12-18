// lib/common/models/flashcard_models.dart

/// Represents a topic/collection of flashcards (e.g., "Midterm Review").
class FlashcardGroup {
  final String id;
  final String courseId;
  final String title;
  final String difficulty;
  final DateTime createdAt;

  /// The UID of the creator.
  /// Required to enforce "Delete as Main Writer" permissions.
  final String userId;

  FlashcardGroup({
    required this.id,
    required this.courseId,
    required this.title,
    required this.difficulty,
    required this.createdAt,
    required this.userId,
  });

  /// Factory to parse Firestore data, handling Timestamp conversions safely.
  factory FlashcardGroup.fromMap(Map<String, dynamic> data, String documentId) {
    return FlashcardGroup(
      id: documentId,
      courseId: data['courseId'] ?? '',
      title: data['title'] ?? '',
      difficulty: data['difficulty'] ?? 'Medium',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      userId: data['userId'] ?? '',
    );
  }

  /// Serializes data for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }
}

/// Represents a specific Question and Answer pair within a group.
class Flashcard {
  final String id;
  final String courseId;
  final String groupId;
  final String question;
  final String solution;
  final String difficulty;
  final DateTime createdAt;

  /// The UID of the creator.
  /// Required to enforce "Delete as Main Writer" permissions.
  final String userId;

  Flashcard({
    required this.id,
    required this.courseId,
    required this.groupId,
    required this.question,
    required this.solution,
    required this.difficulty,
    required this.createdAt,
    required this.userId,
  });

  /// Factory to parse Firestore data, handling Timestamp conversions safely.
  factory Flashcard.fromMap(Map<String, dynamic> data, String documentId) {
    return Flashcard(
      id: documentId,
      courseId: data['courseId'] ?? '',
      groupId: data['groupId'] ?? '',
      question: data['question'] ?? '',
      solution: data['solution'] ?? '',
      difficulty: data['difficulty'] ?? 'Medium',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'groupId': groupId,
      'question': question,
      'solution': solution,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }
}