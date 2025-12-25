import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:su_learning_companion/features/notes/notes_list_screen.dart';
import 'package:su_learning_companion/common/repos/notes_repo.dart';
import 'package:su_learning_companion/common/models/notes.dart';

class FakeNotesRepo implements NotesRepo {
  final _controller = StreamController<List<Note>>.broadcast();

  @override
  Stream<List<Note>> watchNotesForCourse(String courseId) => _controller.stream;

  void emit(List<Note> notes) => _controller.add(notes);

  @override
  Future<List<Note>> getNotesForCourse(String courseId) async => [];

  @override
  Future<void> addNote(Note note) async {}

  @override
  Future<void> removeNote({required String courseId, required String noteId}) async {}

  @override
  Future<void> updateNote({
    required String courseId,
    required String noteId,
    required String title,
    required String content,
  }) async {}

  void dispose() => _controller.close();
}

void main() {
  testWidgets('NotesListScreen shows empty state when stream emits []', (tester) async {
    final repo = FakeNotesRepo();

    await tester.pumpWidget(
      Provider<NotesRepo>.value(
        value: repo,
        child: const MaterialApp(
          home: NotesListScreen(courseId: 'c1', courseName: 'Test Course'),
        ),
      ),
    );


    repo.emit([]);
    await tester.pumpAndSettle();

    expect(find.text('No notes yet'), findsOneWidget);
    expect(find.text('+ Add Note'), findsOneWidget);

    repo.dispose();
  });
}
