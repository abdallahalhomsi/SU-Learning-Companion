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

    // Read createdBy from Firestore; if missing (older notes), fall back to current uid.
    final createdBy = (d['createdBy'] ?? _uid).toString();

    return Note(
      id: doc.id,
      courseId: courseId,
      title: (d['title'] ?? '').toString(),
      content: (d['content'] ?? '').toString(),
      createdAt: createdAt,
      createdBy: createdBy, // ✅ Fix: required param
    );
  }
// single fetch of notes for cources
  @override
  Future<List<Note>> getNotesForCourse(String courseId) async {
    final snap = await _notesCol(courseId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) => _fromDoc(courseId, d)).toList();
  }

  // realtime stream, fetches updated notes
  @override
  Stream<List<Note>> watchNotesForCourse(String courseId) {
    return _notesCol(courseId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((d) => _fromDoc(courseId, d)).toList(),
    );
  }

  @override
  Future<void> addNote(Note note) async {
    await _notesCol(note.courseId).doc(note.id).set({
      'title': note.title,
      'content': note.content,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': note.createdBy, // ✅ Fix: persist owner
    });
  }

  @override
  Future<void> updateNote({ // allows user to edit notes
    required String courseId,
    required String noteId,
    required String title,
    required String content,
  }) async {
    await _notesCol(courseId).doc(noteId).update({
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
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
