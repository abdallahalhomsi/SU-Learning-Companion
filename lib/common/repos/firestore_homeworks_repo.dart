import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/homework.dart';
import 'homeworks_repo.dart';

class FirestoreHomeworksRepo implements HomeworksRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreHomeworksRepo({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> _hwRef(String courseId) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .doc(courseId)
        .collection('homeworks');
  }

  Homework _fromDoc(
      String courseId,
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final d = doc.data() ?? {};
    return Homework(
      id: doc.id,
      courseId: courseId,
      title: (d['title'] ?? '').toString(),
      date: (d['date'] ?? '').toString(),
      time: (d['time'] ?? '').toString(),
    );
  }

  Map<String, dynamic> _toMap(Homework hw) {
    return {
      'title': hw.title,
      'date': hw.date,
      'time': hw.time,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // real time stream (fast+cashed)
  @override
  Stream<List<Homework>> watchHomeworksForCourse(String courseId) {
    return _hwRef(courseId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => _fromDoc(courseId, doc))
          .toList();
    });
  }

  @override
  Future<void> addHomework(Homework homework) async {
    await _hwRef(homework.courseId).add(_toMap(homework));
  }

  @override
  Future<void> removeHomework(String courseId, String homeworkId) async {
    await _hwRef(courseId).doc(homeworkId).delete();
  }
}
