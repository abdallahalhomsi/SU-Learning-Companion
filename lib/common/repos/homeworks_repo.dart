import '../models/homework.dart';

abstract class HomeworksRepo {
  /// Reads: users/{uid}/courses/{courseId}/homeworks
  Stream<List<Homework>> watchHomeworksForCourse(String courseId); // refreshes in real time

  /// Writes: users/{uid}/courses/{courseId}/homeworks/{autoId}
  Future<void> addHomework(Homework homework);

  /// Deletes: users/{uid}/courses/{courseId}/homeworks/{homeworkId}
  Future<void> removeHomework(String courseId, String homeworkId);
}
