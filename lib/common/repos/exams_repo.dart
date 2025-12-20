import '../models/exam.dart';

abstract class ExamsRepo {
  /// Reads (one-time): users/{uid}/courses/{courseId}/exams
  Future<List<Exam>> getExamsForCourse(String courseId);

  /// Real-time stream
  Stream<List<Exam>> watchExamsForCourse(String courseId);

  /// Writes: users/{uid}/courses/{courseId}/exams/{autoId}
  Future<void> addExam(Exam exam);

  /// Deletes: users/{uid}/courses/{courseId}/exams/{examId}
  Future<void> removeExam(String courseId, String examId);

  /// Updates
  Future<void> updateExam(Exam exam);
}
