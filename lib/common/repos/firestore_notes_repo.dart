// lib/common/repos/firestore_notes_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notes.dart';
import 'notes_repo.dart';

class FirestoreNotesRepo implements NotesRepo {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreNotesRepo({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('Not logged in');
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> _notesCol(String courseId) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('courses')
        .doc(courseId)
        .collection('notes');
  }

  Note _fromDoc(String courseId, DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'];

    DateTime createdAt = DateTime.now();
    if (ts is Timestamp) createdAt = ts.toDate();

    return Note(
      id: doc.id,
      courseId: courseId,
      title: (d['title'] ?? '').toString(),
      content: (d['content'] ?? '').toString(),
      createdAt: createdAt,
    );
  }

  @override
  Future<List<Note>> getNotesForCourse(String courseId) async {
    final snap = await _notesCol(courseId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) => _fromDoc(courseId, d)).toList();
  }

  @override
  Future<void> addNote(Note note) async {
    await _notesCol(note.courseId).doc(note.id).set({
      'title': note.title,
      'content': note.content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeNote({
    required String courseId,
    required String noteId,
  }) async {
    await _notesCol(courseId).doc(noteId).delete();
  }
}
