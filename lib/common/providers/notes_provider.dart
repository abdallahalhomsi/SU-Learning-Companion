// lib/common/providers/notes_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notes.dart';
import '../repos/notes_repo.dart';

/// NotesProvider
/// - Holds notes in memory
/// - Loads notes per course using Future-based repo methods
/// - Exposes loading + error states
/// - Supports add + delete
///
/// NOTE: Your current NotesRepo/FirestoreNotesRepo is Future-based (not Stream-based),
/// so this provider uses manual refresh (load) after mutations.
class NotesProvider extends ChangeNotifier {
  final NotesRepo _repo;

  NotesProvider(this._repo);

  List<Note> _notes = [];
  bool _loading = false;
  String? _error;

  String? _activeCourseId;

  List<Note> get notes => _notes;
  bool get isLoading => _loading;
  String? get error => _error;
  String? get activeCourseId => _activeCourseId;

  /// Load notes for a specific course
  Future<void> loadForCourse(String courseId) async {
    _activeCourseId = courseId;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repo.getNotesForCourse(courseId);
      _notes = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Clear cached notes (e.g., on logout or switching contexts)
  void clear() {
    _notes = [];
    _loading = false;
    _error = null;
    _activeCourseId = null;
    notifyListeners();
  }

  /// Add a note (builds Note object correctly)
  Future<void> addNote({
    required String courseId,
    required String title,
    required String content,
  }) async {
    _error = null;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _error = 'Not logged in';
      notifyListeners();
      return;
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: courseId,
      title: title.trim(),
      content: content,
      createdAt: DateTime.now(),
      createdBy: uid,
    );

    try {
      await _repo.addNote(note);

      // refresh list so UI updates
      await loadForCourse(courseId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a note by ID
  Future<void> deleteNote({
    required String courseId,
    required String noteId,
  }) async {
    _error = null;

    try {
      await _repo.removeNote(courseId: courseId, noteId: noteId);

      // refresh list so UI updates
      await loadForCourse(courseId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
