import '../models/course.dart';
abstract class CoursesRepo {
  Stream<List<Course>> watchAll();
  Future<Course> create(Course c);
  Future<void> update(Course c);
  Future<void> delete(String id);
}


/// Contract for reading/writing courses.
/// UI depends on this, not on a concrete backend.
/// Implementations:
/// - FakeCoursesRepo (now)
/// - FirebaseCoursesRepo (later)