import '../models/course.dart';

abstract class CoursesRepo {
  /// Get all courses for the current user
  Future<List<Course>> getCourses();

  /// Get a single course by ID
  Future<Course?> getCourseById(String id);

  /// Search for courses by name or code
  Future<List<Course>> searchCourses(String query);

  /// Add a course to user's list
  Future<void> addCourse(Course course);

  /// Remove a course from user's list
  Future<void> removeCourse(String courseId);

  /// Get all events across all courses
  Future<List<CourseEvent>> getAllEvents();

  /// Get events for a specific month
  Future<List<CourseEvent>> getEventsForMonth(int year, int month);
}

/// Contract for reading/writing courses.
/// UI depends on this, not on a concrete backend.
/// Implementations:
/// - FakeCoursesRepo (now)
/// - FirebaseCoursesRepo (later)