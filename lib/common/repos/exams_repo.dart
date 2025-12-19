import '../models/exam.dart';

abstract class ExamsRepo {
  /// Reads: users/{uid}/courses/{courseId}/exams
  Future<List<Exam>> getExamsForCourse(String courseId);

  /// Writes: users/{uid}/courses/{courseId}/exams/{autoId}
  Future<void> addExam(Exam exam);

  /// Deletes: users/{uid}/courses/{courseId}/exams/{examId}
  Future<void> removeExam(String courseId, String examId);

  Future<void> updateExam(Exam exam);
}
