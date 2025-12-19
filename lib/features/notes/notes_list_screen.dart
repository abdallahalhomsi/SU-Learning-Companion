// lib/features/notes/notes_list_screen.dart
//
// Dark-mode-safe empty state text.

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

class NotesListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;

  const NotesListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    final notesRepo = context.read<NotesRepo>();
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary, size: 20),
          onPressed: () => context.go('/courses/detail/$courseId'),
        ),
        title: Text('Notes: $courseName', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppSpacing.screen,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: StreamBuilder<List<Note>>(
                  stream: notesRepo.watchNotesForCourse(courseId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notes = snapshot.data!;
                    if (notes.isEmpty) {
                      return Center(
                        child: Text(
                          'No notes yet',
                          style: TextStyle(color: onSurface.withValues(alpha: 0.7)),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final note = notes[i];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              note.title,
                              style: const TextStyle(color: AppColors.textOnPrimary),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotesTopicScreen(
                                    courseName: courseName,
                                    note: note,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddNoteScreen(courseId: courseId, courseName: courseName),
                    ),
                  );
                },
                child: const Text('+ Add Note', style: AppTextStyles.primaryButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
