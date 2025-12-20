// lib/common/models/notes.dart
// This file defines the data models for Notes.
// These models are used throughout the application to represent Notes.

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String courseId;
  final String createdBy;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.courseId,
    required this.createdBy,
    required this.createdAt,
  });

  /// Convert Firestore document → Note object
  factory Note.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, {
        required String courseId,
      }) {
    final data = doc.data() ?? {};

    return Note(
      id: doc.id,
      courseId: courseId,
      title: (data['title'] ?? '').toString(),
      content: (data['content'] ?? '').toString(),
      createdBy: (data['createdBy'] ?? '').toString(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert Note → Firestore map (for create/update)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'courseId': courseId,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Helper for updates
  Note copyWith({
    String? title,
    String? content,
  }) {
    return Note(
      id: id,
      courseId: courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }
}
