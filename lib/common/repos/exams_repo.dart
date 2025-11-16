import '../models/exam.dart';

abstract class ExamsRepo {
  List<Exam> getExamsForCourse(String courseId);
  void addExam(Exam exam);
  void removeExam(String examId);
}