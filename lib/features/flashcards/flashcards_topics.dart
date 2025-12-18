// lib/features/flashcards/flashcards_topics.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

import '../../common/models/flashcard.dart'; // <--- Ensure this matches your file name
import '../../common/repos/flashcards_repo.dart';

class FlashcardsTopicsScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const FlashcardsTopicsScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<FlashcardsTopicsScreen> createState() => _FlashcardsTopicsScreenState();
}

class _FlashcardsTopicsScreenState extends State<FlashcardsTopicsScreen> {
  late final FlashcardsRepo _repo;
  bool _repoReady = false;

  late Future<List<FlashcardGroup>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _repo = context.read<FlashcardsRepo>();
      _repoReady = true;
      // FIX 1: Use the correct method name from the interface
      _future = _repo.getFlashcardGroups(widget.courseId);
    }
  }

  void _refresh() {
    setState(() {
      // FIX 2: Use the correct method name
      _future = _repo.getFlashcardGroups(widget.courseId);
    });
  }

  Future<void> _deleteGroup(FlashcardGroup group) async {
    try {
      // FIX 3: Use correct method name and positional arguments
      await _repo.deleteFlashcardGroup(widget.courseId, group.id);

      if (!mounted) return;
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete group: $e')),
      );
    }
  }

  Future<void> _addGroup() async {
    // FIX 4: Simplified Logic
    // We navigate to the Form Sheet and pass the courseId.
    // The Form Sheet now handles the saving to Firebase.
    await context.push('/flashcards/groups/add', extra: {'courseId': widget.courseId});

    // When we return, we just refresh the list to show the new item.
    if (!mounted) return;
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: AppColors.textOnPrimary,
          onPressed: () => context.go('/courses/detail/${widget.courseId}'),
        ),
        title: Text(
          'Flash Cards : ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
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
                ),
                child: FutureBuilder<List<FlashcardGroup>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final groups = snapshot.data ?? [];
                    if (groups.isEmpty) {
                      return const Center(
                        child: Text(
                          'No flashcard groups yet.',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: groups.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.gapMedium),
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return _GroupButton(
                          title: '${group.title}: ${group.difficulty}',
                          onTap: () {
                            context.push(
                              '/courses/${widget.courseId}/flashcards/${group.id}/questions',
                              extra: {
                                'groupTitle': group.title,
                                'courseName': widget.courseName,
                              },
                            );
                          },
                          onDelete: () => _deleteGroup(group),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gapMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  '+ Add Flash Card Group',
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

class _GroupButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GroupButton({
    required this.title,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Text(title, style: AppTextStyles.listButton, textAlign: TextAlign.center),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.textOnPrimary),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}