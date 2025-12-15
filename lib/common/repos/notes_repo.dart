// lib/common/repos/notes_repo.dart
import '../models/notes.dart';

abstract class NotesRepo {
  Future<List<Note>> getNotesForCourse(String courseId);

  Future<void> addNote(Note note);

  Future<void> removeNote({
    required String courseId,
    required String noteId,
  });
}
