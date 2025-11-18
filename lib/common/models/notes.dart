// This file defines the data models for Notes.
// These models are used throughout the application to represent Notes.
class Note {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}// later