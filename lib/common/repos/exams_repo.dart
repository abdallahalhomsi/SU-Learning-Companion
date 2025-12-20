import '../models/exam.dart';

abstract class ExamsRepo {

  Future<List<Exam>> getExamsForCourse(String courseId);


  Stream<List<Exam>> watchExamsForCourse(String courseId);


  Future<void> addExam(Exam exam);


  Future<void> removeExam(String courseId, String examId);

  /// Updates
  Future<void> updateExam(Exam exam);
}
