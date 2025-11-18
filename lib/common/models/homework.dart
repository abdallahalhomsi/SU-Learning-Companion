// This file defines the data models for Homeworks.
// These models are used throughout the application to represent Homeworks.
class Homework {
  final String id;
  final String courseId;
  final String title;
  final String date;   // due date
  final String time;   // due time

  Homework({
    required this.id,
    required this.courseId,
    required this.title,
    required this.date,
    required this.time,
  });
}