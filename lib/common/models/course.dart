class Course {
  final String id, code, name, term;
  final String? instructor;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.term,
    this.instructor,
    required this.createdAt,
  });

  Map<String,dynamic> toMap() => {
    'code': code,
    'name': name,
    'term': term,
    'instructor': instructor,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Course.fromMap(String id, Map<String,dynamic> m) => Course(
    id: id,
    code: m['code'],
    name: m['name'],
    term: m['term'],
    instructor: m['instructor'],
    createdAt: DateTime.parse(m['createdAt']),
  );
}

class CourseEvent {
  final String id;
  final String courseId;
  final String title;
  final CourseEventType type;
  final DateTime dueDate;
  final String? description;

  CourseEvent({
    required this.id,
    required this.courseId,
    required this.title,
    required this.type,
    required this.dueDate,
    this.description,
  });

  Map<String, dynamic> toMap() => {
    'courseId': courseId,
    'title': title,
    'type': type.toString(),
    'dueDate': dueDate.toIso8601String(),
    'description': description,
  };

  factory CourseEvent.fromMap(String id, Map<String, dynamic> m) => CourseEvent(
    id: id,
    courseId: m['courseId'],
    title: m['title'],
    type: CourseEventType.values.firstWhere(
          (e) => e.toString() == m['type'],
    ),
    dueDate: DateTime.parse(m['dueDate']),
    description: m['description'],
  );
}

enum CourseEventType {
  exam,
  homework,
  deadline,
  quiz,
}

extension CourseEventTypeExtension on CourseEventType {
  String get displayName {
    switch (this) {
      case CourseEventType.exam:
        return 'Exam';
      case CourseEventType.homework:
        return 'Homework';
      case CourseEventType.deadline:
        return 'Deadline';
      case CourseEventType.quiz:
        return 'Quiz';
    }
  }
}

/// Data model: Course.
/// - No Flutter imports.
/// - toMap/fromMap for storage.
/// Future: add fields if needed (section, room).