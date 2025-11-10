import 'dart:async';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';

class FakeCoursesRepo implements CoursesRepo {
  // Separate storage for user courses and events
  final List<Course> _userCourses = [
    Course(
      id: '1',
      code: 'CS 301',
      name: 'Mobile App Development',
      term: 'Fall 2025',
      instructor: 'Prof. Saima Gul',
      createdAt: DateTime(2025, 9, 1),
    ),
    Course(
      id: '2',
      code: 'CS 300',
      name: 'Data Structures',
      term: 'Fall 2025',
      instructor: 'Prof. Cemal Yilmaz',
      createdAt: DateTime(2025, 9, 1),
    ),
  ];

  // Store events separately since they're not part of Course model
  final List<CourseEvent> _events = [
    CourseEvent(
      id: 'e1',
      courseId: '1',
      title: 'Midterm Exam',
      type: CourseEventType.exam,
      dueDate: DateTime(2025, 11, 15, 14, 0),
      description: 'Chapters 1-5',
    ),
    CourseEvent(
      id: 'e2',
      courseId: '1',
      title: 'Project Submission',
      type: CourseEventType.deadline,
      dueDate: DateTime(2025, 12, 1, 23, 59),
      description: 'Final project deadline',
    ),
    CourseEvent(
      id: 'e3',
      courseId: '2',
      title: 'Quiz 3',
      type: CourseEventType.quiz,
      dueDate: DateTime(2025, 11, 20, 10, 0),
    ),
    CourseEvent(
      id: 'e4',
      courseId: '2',
      title: 'Homework 5',
      type: CourseEventType.homework,
      dueDate: DateTime(2025, 11, 25, 23, 59),
      description: 'Binary trees and graphs',
    ),
    CourseEvent(
      id: 'e5',
      courseId: '1',
      title: 'Assignment 3',
      type: CourseEventType.homework,
      dueDate: DateTime(2025, 11, 12, 23, 59),
      description: 'Flutter widgets practice',
    ),
    CourseEvent(
      id: 'e6',
      courseId: '2',
      title: 'Final Exam',
      type: CourseEventType.exam,
      dueDate: DateTime(2025, 12, 18, 14, 0),
      description: 'Comprehensive final',
    ),
  ];

  final List<Course> _availableCourses = [
    Course(
      id: '3',
      code: 'CS 306',
      name: 'Database Systems',
      term: 'Fall 2025',
      instructor: 'Dr. Williams',
      createdAt: DateTime(2025, 9, 1),
    ),
    Course(
      id: '4',
      code: 'CS 310',
      name: 'App Development',
      term: 'Fall 2025',
      instructor: 'Prof. Saima Gul',
      createdAt: DateTime(2025, 9, 1),
    ),
    Course(
      id: '5',
      code: 'CS 401',
      name: 'Algorithm Design',
      term: 'Fall 2025',
      instructor: 'Dr. Davis',
      createdAt: DateTime(2025, 9, 1),
    ),
    Course(
      id: '6',
      code: 'CS 320',
      name: 'Computer Networks',
      term: 'Fall 2025',
      instructor: 'Prof. Garcia',
      createdAt: DateTime(2025, 9, 1),
    ),
    Course(
      id: '7',
      code: 'CS 250',
      name: 'Software Engineering',
      term: 'Fall 2025',
      instructor: 'Dr. Martinez',
      createdAt: DateTime(2025, 9, 1),
    ),
    Course(
      id: '8',
      code: 'CS 205',
      name: 'Operating Systems',
      term: 'Fall 2025',
      instructor: 'Prof. Lee',
      createdAt: DateTime(2025, 9, 1),
    ),
  ];

  @override
  Future<List<Course>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_userCourses);
  }

  @override
  Future<Course?> getCourseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _userCourses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Course>> searchCourses(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (query.isEmpty) {
      return List.from(_availableCourses);
    }

    final lowerQuery = query.toLowerCase();
    return _availableCourses.where((course) {
      return course.name.toLowerCase().contains(lowerQuery) ||
          course.code.toLowerCase().contains(lowerQuery) ||
          (course.instructor?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  @override
  Future<void> addCourse(Course course) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_userCourses.any((c) => c.id == course.id)) {
      _userCourses.add(course);
    }
  }

  @override
  Future<void> removeCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userCourses.removeWhere((course) => course.id == courseId);
  }

  @override
  Future<List<CourseEvent>> getAllEvents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Only return events for courses the user is enrolled in
    final userCourseIds = _userCourses.map((c) => c.id).toSet();
    final userEvents = _events
        .where((event) => userCourseIds.contains(event.courseId))
        .toList();
    userEvents.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return userEvents;
  }

  @override
  Future<List<CourseEvent>> getEventsForMonth(int year, int month) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allEvents = await getAllEvents();
    return allEvents.where((event) {
      return event.dueDate.year == year && event.dueDate.month == month;
    }).toList();
  }

  // Helper method to get course name by ID (useful for displaying events)
  String? getCourseNameById(String courseId) {
    try {
      return _userCourses.firstWhere((c) => c.id == courseId).name;
    } catch (e) {
      return null;
    }
  }
}

/// In-memory CoursesRepo for development.
/// - Streams a mutable Map snapshot.
/// - No persistence; resets on app restart.
/// Future: remove/keep for unit tests.