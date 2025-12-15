import '../models/course.dart';

abstract class CoursesRepo {
  /// Global catalog (courses collection)
  Future<List<Course>> getAllCourses();
  Future<List<Course>> getCourses();              // user’s added courses
  Future<Course?> getCourseById(String courseId); // single user course
  /// User’s added courses (users/{uid}/courses)
  Future<List<Course>> getUserCourses();

  /// Add from catalog into user courses
  Future<void> addCourseToUser(Course course);

  /// Remove from user courses
  Future<void> removeUserCourse(String courseId);

  /// Optional helper: search global catalog (you can also filter locally in UI)
  Future<List<Course>> searchAllCourses(String query);
}
