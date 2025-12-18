// lib/features/notes/notes_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/models/notes.dart';
import '../../common/repos/notes_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

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
  late final NotesRepo _notesRepo;
  bool _repoReady = false;

  late Future<List<Note>> _futureNotes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _notesRepo = context.read<NotesRepo>();
      _repoReady = true;
      _futureNotes = _notesRepo.getNotesForCourse(widget.courseId);
    }
  }

  void _refresh() {
    setState(() {
      _futureNotes = _notesRepo.getNotesForCourse(widget.courseId);
    });
  }

  // refreshes list after returning from topic screen to get updated notes
  Future<void> _openTopic(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotesTopicScreen(
          courseName: widget.courseName,
          note: note,
        ),
      ),
    );

    if (!mounted) return;
    _refresh();
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
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _notesRepo.removeNote(
                  courseId: widget.courseId,
                  noteId: note.id,
                );
                if (!mounted) return;
                _refresh();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete note: $e')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.errorRed),
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
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
          onPressed: () => context.go('/courses/detail/${widget.courseId}'),
        ),
        title: Text(
          'Notes: ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.screen,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5EAF1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: FutureBuilder<List<Note>>(
                  future: _futureNotes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    final notes = snapshot.data ?? [];
                    if (notes.isEmpty) {
                      return const Center(
                        child: Text(
                          'No notes yet',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.gapMedium),
                      itemBuilder: (context, i) {
                        final note = notes[i];
                        return SizedBox(
                          height: 44,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              dense: true,
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              title: Text(
                                note.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textOnPrimary,
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
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gapMedium),
            SizedBox(
              height: 46,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textOnPrimary,
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
                    if (added == true) _refresh();
                  });
                },
                child: const Text(
                  '+ Add Note',
                  style: AppTextStyles.primaryButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
