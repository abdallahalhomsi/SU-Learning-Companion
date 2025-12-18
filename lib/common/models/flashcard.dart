// lib/common/models/flashcard_models.dart

class FlashcardGroup {
  final String id;
  final String courseId;
  final String title;
  final String difficulty; // Easy/Medium/Hard
  final DateTime createdAt;
  final String userId; // <--- ADD THIS FIELD

  FlashcardGroup({
    required this.id,
    required this.courseId,
    required this.title,
    required this.difficulty,
    required this.createdAt,
    required this.userId, // <--- ADD TO CONSTRUCTOR
  });

  // Convert from Firestore
  factory FlashcardGroup.fromMap(Map<String, dynamic> data, String documentId) {
    return FlashcardGroup(
      id: documentId,
      courseId: data['courseId'] ?? '',
      title: data['title'] ?? '',
      difficulty: data['difficulty'] ?? 'Medium',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      userId: data['userId'] ?? '', // <--- READ IT
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId, // <--- SAVE IT
    };
  }
}

class Flashcard {
  final String id;
  final String courseId;
  final String groupId;
  final String question;
  final String solution;
  final String difficulty; // Easy/Medium/Hard
  final DateTime createdAt;
  final String userId; // <--- ADD THIS FIELD

  Flashcard({
    required this.id,
    required this.courseId,
    required this.groupId,
    required this.question,
    required this.solution,
    required this.difficulty,
    required this.createdAt,
    required this.userId, // <--- ADD TO CONSTRUCTOR
  });

  // Convert from Firestore
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
      userId: data['userId'] ?? '', // <--- READ IT
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'groupId': groupId,
      'question': question,
      'solution': solution,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId, // <--- SAVE IT
    };
  }
}