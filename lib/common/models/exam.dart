// This file defines the data models for Exams
// These models are used throughout the application to represent exams

class Exam {
  final String id;        // unique per exam
  final String courseId;  // which course it belongs to
  final String title;     // e.g. "Midterm 1"
  final String date;      // e.g. "2025-03-10"
  final String time;      // e.g. "09:00"


  final String createdBy; // user uid
  final DateTime createdAt;

  Exam({
    required this.id,
    required this.courseId,
    required this.title,
    required this.date,
    required this.time,
    required this.createdBy,
    required this.createdAt,
  });


  factory Exam.fromMap(String id, String courseId, Map<String, dynamic> d) {
    return Exam(
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
