import '../models/course.dart';

abstract class CoursesRepo {

  Future<List<Course>> getAllCourses();

  Future<List<Course>> getCourses();
  Future<Course?> getCourseById(String courseId);
  Future<List<Course>> getUserCourses();


  Stream<List<Course>> watchUserCourses();


  Future<void> addCourseToUser(Course course);


  Future<void> removeUserCourse(String courseId);


  Future<List<Course>> searchAllCourses(String query);
}
