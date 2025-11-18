// This abstract class defines the contract for a repository that manages exams.
// It provides methods for retrieving, adding, and removing exams.
import '../models/exam.dart';

abstract class ExamsRepo {
  List<Exam> getExamsForCourse(String courseId);
  void addExam(Exam exam);
  void removeExam(String examId);
}