import '../models/notes.dart';

abstract class NotesRepo {
  List<Note> getNotesForCourse(String courseId);
  void addNote(Note note);
  void removeNote(String noteId);
}
