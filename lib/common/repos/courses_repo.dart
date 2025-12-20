import '../models/course.dart';

abstract class CoursesRepo {
  /// Global catalog (courses collection)
  Future<List<Course>> getAllCourses();

  /// User’s added courses (users/{uid}/courses)
  Future<List<Course>> getCourses();
  Future<Course?> getCourseById(String courseId);
  Future<List<Course>> getUserCourses();

  /// ✅ Real-time: user’s courses
  Stream<List<Course>> watchUserCourses();

  /// Add from catalog into user courses
  Future<void> addCourseToUser(Course course);

  /// Remove from user courses
  Future<void> removeUserCourse(String courseId);

  /// Optional helper: search global catalog (you can also filter locally in UI)
  Future<List<Course>> searchAllCourses(String query);
}
