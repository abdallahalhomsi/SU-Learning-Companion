// This abstract class defines the contract for a repository that manages notes.
// It provides methods for retrieving, adding, and removing notes.
import '../models/notes.dart';

abstract class NotesRepo {
  List<Note> getNotesForCourse(String courseId);
  void addNote(Note note);
  void removeNote(String noteId);
}
