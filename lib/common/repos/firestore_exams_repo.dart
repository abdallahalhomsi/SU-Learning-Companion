// lib/common/repos/firestore_exams_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/exam.dart';
import 'exams_repo.dart';

class FirestoreExamsRepo implements ExamsRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreExamsRepo({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> _examsRef(String courseId) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .doc(courseId)
        .collection('exams');
  }

  Exam _fromDoc(String courseId, DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Exam.fromMap(doc.id, courseId, d);
  }

  Map<String, dynamic> _toMapForCreate(Exam exam) {
    return {
      'title': exam.title,
      'date': exam.date,
      'time': exam.time,
      'createdAt': FieldValue.serverTimestamp(),
      // ✅ Added (required)
      'createdBy': _uid,
    };
  }

  Map<String, dynamic> _toMapForUpdate(Exam exam) {
    return {
      'title': exam.title,
      'date': exam.date,
      'time': exam.time,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  Future<List<Exam>> getExamsForCourse(String courseId) async {
    final snap = await _examsRef(courseId).get();
    final exams = snap.docs.map((d) => _fromDoc(courseId, d)).toList();

    exams.sort((a, b) => a.date.compareTo(b.date));
    return exams;
  }

  // ✅ Added (real-time updates requirement)
  @override
  Stream<List<Exam>> watchExamsForCourse(String courseId) {
    return _examsRef(courseId)
        .snapshots()
        .map((snap) => snap.docs.map((d) => _fromDoc(courseId, d)).toList());
  }

  @override
  Future<void> addExam(Exam exam) async {
    await _examsRef(exam.courseId).add(_toMapForCreate(exam));
  }

  @override
  Future<void> removeExam(String courseId, String examId) async {
    await _examsRef(courseId).doc(examId).delete();
  }

  @override
  Future<void> updateExam(Exam exam) async {
    if (exam.id.trim().isEmpty) {
      throw Exception('Exam id is missing (cannot update).');
    }
    await _examsRef(exam.courseId).doc(exam.id).update(_toMapForUpdate(exam));
  }
}
