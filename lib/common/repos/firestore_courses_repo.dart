// lib/common/repos/firestore_courses_repo.dart

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

  DateTime _readDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  Course _courseFromCatalogDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Course(
      id: doc.id,
      code: (d['courseCode'] ?? '').toString(),
      name: (d['courseName'] ?? '').toString(),
      term: (d['semester'] ?? '').toString(),
      instructor: d['instructor']?.toString(),
      createdBy: (d['createdBy'] ?? 'catalog').toString(),
      createdAt: _readDate(d['createdAt']),
    );
  }

  Course _courseFromUserDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Course(
      id: doc.id,
      code: (d['courseCode'] ?? '').toString(),
      name: (d['courseName'] ?? '').toString(),
      term: (d['semester'] ?? '').toString(),
      instructor: d['instructor']?.toString(),
      createdBy: (d['createdBy'] ?? _uid).toString(),
      createdAt: _readDate(d['createdAt']),
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
    final ref =
    _db.collection('users').doc(_uid).collection('courses').doc(course.id);

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
      'createdBy': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeUserCourse(String courseId) async {
    await _db.collection('users').doc(_uid).collection('courses').doc(courseId).delete();
  }

  @override
  Future<List<Course>> searchAllCourses(String query) async {
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
  @override
  Stream<List<Course>> watchUserCourses() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .orderBy('courseCode')
        .snapshots()
        .map((snap) => snap.docs.map(_courseFromUserDoc).toList());
  }
}
