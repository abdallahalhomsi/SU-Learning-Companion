// This file defines the data models for Homeworks.
// These models are used throughout the application to represent Homeworks.

class Homework {
  final String id;
  final String courseId;
  final String title;
  final String date;   // due date
  final String time;   // due time
  final String createdBy; // user uid
  final DateTime createdAt;

  Homework({
    required this.id,
    required this.courseId,
    required this.title,
    required this.date,
    required this.time,
    required this.createdBy,
    required this.createdAt,
  });

  factory Homework.fromMap(String id, String courseId, Map<String, dynamic> d) {
    return Homework(
      id: id,
      courseId: courseId,
      title: (d['title'] ?? '').toString(),
      date: (d['date'] ?? '').toString(),
      time: (d['time'] ?? '').toString(),
      createdBy: (d['createdBy'] ?? '').toString(),
      createdAt: d['createdAt'] is DateTime
          ? d['createdAt']
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
