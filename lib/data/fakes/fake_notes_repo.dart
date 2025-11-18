import '../../common/models/notes.dart';
import '../../common/repos/notes_repo.dart';

class FakeNotesRepo implements NotesRepo {
  FakeNotesRepo._internal();
  static final FakeNotesRepo _instance = FakeNotesRepo._internal();
  factory FakeNotesRepo() => _instance;

  final List<Note> _items = [
    Note(
      id: 'n1',
      courseId: '1', // CS 301 (Mobile App Development)
      title: 'Topic 1',
      content: 'Intro to Flutter widgets.',
      createdAt: DateTime(2025, 10, 1),
    ),
    Note(
      id: 'n2',
      courseId: '2',
      title: 'Topic 2',
      content: 'Stateful vs Stateless widgets.',
      createdAt: DateTime(2025, 10, 5),
    ),
    Note(
      id: 'n3',
      courseId: '3', // CS 300 (Data Structures)
      title: 'Topic 1',
      content: 'Arrays and linked lists.',
      createdAt: DateTime(2025, 10, 3),
    ),
  ];

  @override
  List<Note> getNotesForCourse(String courseId) =>
      _items.where((n) => n.courseId == courseId).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  @override
  void addNote(Note note) {
    _items.add(note);
  }

  @override
  void removeNote(String noteId) {
    _items.removeWhere((n) => n.id == noteId);
  }
}
