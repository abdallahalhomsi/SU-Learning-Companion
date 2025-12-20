import '../models/homework.dart';

abstract class HomeworksRepo {
  /// Reads: users/{uid}/courses/{courseId}/homeworks
  Future<List<Homework>> getHomeworksForCourse(String courseId);

  // ✅ Added (real-time updates requirement)
  Stream<List<Homework>> watchHomeworksForCourse(String courseId);

  /// Writes: users/{uid}/courses/{courseId}/homeworks/{autoId}
  Future<void> addHomework(Homework homework);

  /// Deletes: users/{uid}/courses/{courseId}/homeworks/{homeworkId}
  Future<void> removeHomework(String courseId, String homeworkId);

  Future<void> updateHomework(Homework homework);
}
