// This abstract class defines the contract for a repository that manages courses and course events.
// It provides methods for retrieving, searching, adding, and removing courses, as well as fetching course events.
import '../models/course.dart';

abstract class CoursesRepo {
  Future<List<Course>> getCourses();
  Future<Course?> getCourseById(String id);
  Future<List<Course>> searchCourses(String query);
  Future<void> addCourse(Course course);
  Future<void> removeCourse(String courseId);
  Future<List<CourseEvent>> getAllEvents();
  Future<List<CourseEvent>> getEventsForMonth(int year, int month);
}
