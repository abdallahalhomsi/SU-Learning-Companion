import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/models/notes.dart';
import '../../common/repos/notes_repo.dart';
import '../../data/fakes/fake_notes_repo.dart';

import 'notes_topic_screen.dart';
import 'add_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const NotesListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  static const _barBlue = Color(0xFF003366);

  final NotesRepo _notesRepo = FakeNotesRepo();
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    final items = _notesRepo.getNotesForCourse(widget.courseId);
    setState(() {
      _notes = items;
      _isLoading = false;
    });
  }

  void _openTopic(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotesTopicScreen(
          courseName: widget.courseName,
          note: note,
        ),
      ),
    );
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _notesRepo.removeNote(note.id);
                _notes = _notesRepo.getNotesForCourse(widget.courseId);
              });
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: _barBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            // EXACTLY like exams/homeworks: go back to detailed course
            context.go('/courses/detail/${widget.courseId}');
          },
        ),
        title: Text(
          'Notes: ${widget.courseName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5EAF1)),
                ),
                padding: const EdgeInsets.all(12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _notes.isEmpty
                    ? const Center(
                  child: Text(
                    'No notes yet',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
                    : ListView.separated(
                  itemCount: _notes.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final note = _notes[i];
                    return SizedBox(
                      height: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _barBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 12),
                          title: Text(
                            note.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () => _openTopic(note),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white70,
                              size: 20,
                            ),
                            splashRadius: 18,
                            onPressed: () => _confirmDelete(note),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 46,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _barBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddNoteScreen(
                        courseId: widget.courseId,
                        courseName: widget.courseName,
                      ),
                    ),
                  ).then((added) {
                    if (added == true) {
                      _loadNotes();
                    }
                  });
                },
                child: const Text(
                  '+ Add Note',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
