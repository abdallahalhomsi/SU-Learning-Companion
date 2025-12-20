// lib/common/models/course.dart
// This file defines the data models for Course and Calendar.
// These models are used throughout the application to represent courses and their associated events.

import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id, code, name, term;
  final String? instructor;

  // ✅ Required by rubric
  final String createdBy;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.term,
    this.instructor,
    required this.createdBy,
    required this.createdAt,
  });

  /// Firestore write map (use Timestamp)
  Map<String, dynamic> toMap() => {
    'code': code,
    'name': name,
    'term': term,
    'instructor': instructor,
    'createdBy': createdBy,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  /// Firestore read map
  factory Course.fromMap(String id, Map<String, dynamic> m) {
    final createdAtRaw = m['createdAt'];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : (createdAtRaw is String
        ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
        : DateTime.now());

    return Course(
      id: id,
      code: (m['code'] ?? '').toString(),
      name: (m['name'] ?? '').toString(),
      term: (m['term'] ?? '').toString(),
      instructor: m['instructor']?.toString(),
      createdBy: (m['createdBy'] ?? '').toString(),
      createdAt: createdAt,
    );
  }
}

class CourseEvent {
  final String id;
  final String courseId;
  final String title;
  final CourseEventType type;
  final DateTime dueDate;
  final String? description;

  // ✅ If this is stored in Firestore, include these.
  // If it is ONLY a UI helper and never stored, you can keep them anyway harmlessly.
  final String createdBy;
  final DateTime createdAt;

  CourseEvent({
    required this.id,
    required this.courseId,
    required this.title,
    required this.type,
    required this.dueDate,
    this.description,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'courseId': courseId,
    'title': title,
    'type': type.toString(),
    'dueDate': Timestamp.fromDate(dueDate),
    'description': description,
    'createdBy': createdBy,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory CourseEvent.fromMap(String id, Map<String, dynamic> m) {
    DateTime _readDate(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      return DateTime.now();
    }

    return CourseEvent(
      id: id,
      courseId: (m['courseId'] ?? '').toString(),
      title: (m['title'] ?? '').toString(),
      type: CourseEventType.values.firstWhere(
            (e) => e.toString() == (m['type'] ?? '').toString(),
        orElse: () => CourseEventType.homework,
      ),
      dueDate: _readDate(m['dueDate']),
      description: m['description']?.toString(),
      createdBy: (m['createdBy'] ?? '').toString(),
      createdAt: _readDate(m['createdAt']),
    );
  }
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
