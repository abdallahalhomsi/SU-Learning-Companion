import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/course.dart';
import 'courses_repo.dart';

class FirestoreCoursesRepo implements CoursesRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreCoursesRepo({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  Course _courseFromCatalogDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Course(
      id: doc.id, // courseId = docId ("0"..."n")
      code: (d['courseCode'] ?? '').toString(),
      name: (d['courseName'] ?? '').toString(),
      term: (d['semester'] ?? '').toString(),
      instructor: (d['instructor'] ?? '').toString(),
      createdAt: DateTime.now(), // model requires it
    );
  }

  Course _courseFromUserDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Course(
      id: doc.id,
      code: (d['courseCode'] ?? '').toString(),
      name: (d['courseName'] ?? '').toString(),
      term: (d['semester'] ?? '').toString(),
      instructor: (d['instructor'] ?? '').toString(),
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<Course>> getAllCourses() async {
    final snap = await _db.collection('courses').orderBy('courseCode').get();
    return snap.docs.map(_courseFromCatalogDoc).toList();
  }

  @override
  Future<List<Course>> getUserCourses() async {
    final snap = await _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .orderBy('courseCode')
        .get();

    return snap.docs.map(_courseFromUserDoc).toList();
  }

  @override
  Future<void> addCourseToUser(Course course) async {
    final ref = _db.collection('users').doc(_uid).collection('courses').doc(course.id);

    final existing = await ref.get();
    if (existing.exists) {
      throw Exception('Course already added');
    }

    await ref.set({
      'courseId': course.id,
      'courseCode': course.code,
      'courseName': course.name,
      'semester': course.term,
      'instructor': course.instructor,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeUserCourse(String courseId) async {
    await _db.collection('users').doc(_uid).collection('courses').doc(courseId).delete();
  }

  @override
  Future<List<Course>> searchAllCourses(String query) async {
    // simplest + reliable: fetch all and filter (small dataset)
    final all = await getAllCourses();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;

    return all.where((c) {
      final code = c.code.toLowerCase();
      final name = c.name.toLowerCase();
      final instructor = (c.instructor ?? '').toLowerCase();
      return code.contains(q) || name.contains(q) || instructor.contains(q);
    }).toList();
  }
  @override
  Future<List<Course>> getCourses() async {
    // User’s added courses: users/{uid}/courses
    return getUserCourses();
  }

  @override
  Future<Course?> getCourseById(String courseId) async {
    final doc = await _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .doc(courseId)
        .get();

    if (!doc.exists) return null;
    return _courseFromUserDoc(doc);
  }
}

