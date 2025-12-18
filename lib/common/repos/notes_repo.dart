// lib/common/repos/notes_repo.dart
import '../models/notes.dart';

abstract class NotesRepo {
  Future<List<Note>> getNotesForCourse(String courseId); // one time fetch

  Stream<List<Note>> watchNotesForCourse(String courseId);// real time update stream for notes

  Future<void> addNote(Note note);

  Future<void> removeNote({
    required String courseId,
    required String noteId,
  });

  Future<void> updateNote({ //  added editable notes
    required String courseId,
    required String noteId,
    required String content,
  });
}
