// lib/common/repos/notes_repo.dart
import '../models/notes.dart';

abstract class NotesRepo {
  Stream<List<Note>> watchNotes(String uid);

  Future<void> addNote(String uid, {required String title, required String content});
  Future<void> updateNote(String uid, Note note);
  Future<void> deleteNote(String uid, String noteId);
}
