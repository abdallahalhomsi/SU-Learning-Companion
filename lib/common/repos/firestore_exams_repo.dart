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
    return Exam(
      id: doc.id,
      courseId: courseId,
      title: (d['title'] ?? '').toString(),
      date: (d['date'] ?? '').toString(),
      time: (d['time'] ?? '').toString(),
    );
  }

  Map<String, dynamic> _toMap(Exam exam) {
    return {
      'title': exam.title,
      'date': exam.date,
      'time': exam.time,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  Future<List<Exam>> getExamsForCourse(String courseId) async {
    final snap = await _examsRef(courseId).get();
    final exams = snap.docs.map((d) => _fromDoc(courseId, d)).toList();

    // Optional: basic client-side sort if date is like YYYY-MM-DD.
    exams.sort((a, b) => (a.date).compareTo(b.date));
    return exams;
  }

  @override
  Future<void> addExam(Exam exam) async {
    // exam.courseId determines where it goes
    await _examsRef(exam.courseId).add(_toMap(exam));
  }

  @override
  Future<void> removeExam(String courseId, String examId) async {
    await _examsRef(courseId).doc(examId).delete();
  }
}
