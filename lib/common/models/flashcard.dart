// lib/common/models/flashcard_models.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a topic/collection of flashcards (e.g., "Midterm Review").
class FlashcardGroup {
  final String id;
  final String courseId;
  final String title;
  final String difficulty;

  // ✅ Required by rubric
  final String createdBy;
  final DateTime createdAt;

  /// Kept (DO NOT remove) for your existing “Main Writer” logic.
  /// You can store it too, but it should match createdBy.
  final String userId;

  FlashcardGroup({
    required this.id,
    required this.courseId,
    required this.title,
    required this.difficulty,
    required this.createdAt,
    required this.userId,
    required this.createdBy,
  });

  /// Factory to parse Firestore data, handling Timestamp conversions safely.
  factory FlashcardGroup.fromMap(Map<String, dynamic> data, String documentId) {
    final createdAtRaw = data['createdAt'];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : (createdAtRaw is String
        ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
        : DateTime.now());

    final createdBy = (data['createdBy'] ?? data['userId'] ?? '').toString();

    return FlashcardGroup(
      id: documentId,
      courseId: (data['courseId'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      difficulty: (data['difficulty'] ?? 'Medium').toString(),
      createdAt: createdAt,
      userId: (data['userId'] ?? createdBy).toString(),
      createdBy: createdBy,
    );
  }

  /// Serializes data for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'difficulty': difficulty,
      'createdAt': Timestamp.fromDate(createdAt),
      // ✅ rubric field
      'createdBy': createdBy,
      // ✅ kept for backwards compatibility
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

  // ✅ Required by rubric
  final String createdBy;
  final DateTime createdAt;

  /// Kept (DO NOT remove) for your existing “Main Writer” logic.
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
    required this.createdBy,
  });

  /// Factory to parse Firestore data, handling Timestamp conversions safely.
  factory Flashcard.fromMap(Map<String, dynamic> data, String documentId) {
    final createdAtRaw = data['createdAt'];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : (createdAtRaw is String
        ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
        : DateTime.now());

    final createdBy = (data['createdBy'] ?? data['userId'] ?? '').toString();

    return Flashcard(
      id: documentId,
      courseId: (data['courseId'] ?? '').toString(),
      groupId: (data['groupId'] ?? '').toString(),
      question: (data['question'] ?? '').toString(),
      solution: (data['solution'] ?? '').toString(),
      difficulty: (data['difficulty'] ?? 'Medium').toString(),
      createdAt: createdAt,
      userId: (data['userId'] ?? createdBy).toString(),
      createdBy: createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'groupId': groupId,
      'question': question,
      'solution': solution,
      'difficulty': difficulty,
      'createdAt': Timestamp.fromDate(createdAt),
      // ✅ rubric field
      'createdBy': createdBy,
      // ✅ kept for backwards compatibility
      'userId': userId,
    };
  }
}
