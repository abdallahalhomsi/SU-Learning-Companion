class Exam {
  final String id;        // unique per exam
  final String courseId;  // which course it belongs to
  final String title;     // e.g. "Midterm 1"
  final String date;      // e.g. "2025-03-10" or "10.03.2025"
  final String time;      // e.g. "09:00"

  Exam({
    required this.id,
    required this.courseId,
    required this.title,
    required this.date,
    required this.time,
  });
}