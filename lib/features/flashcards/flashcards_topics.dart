// This file makes up the components of the Flashcards Topics Screen,
// Which displays a list of flashcard groups for a specific course.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class FlashcardsTopicsScreen extends StatefulWidget {
  final String? courseId;
  final String courseName;

  const FlashcardsTopicsScreen({
    super.key,
    this.courseId,
    this.courseName = 'Course Name',
  });

  @override
  State<FlashcardsTopicsScreen> createState() => _FlashcardsTopicsScreenState();
}

class _FlashcardsTopicsScreenState extends State<FlashcardsTopicsScreen> {
  static final List<_FlashcardGroup> _groups = [
    _FlashcardGroup(title: 'Chapter X', difficulty: 'Easy'),
    _FlashcardGroup(title: 'Lecture Slides Y', difficulty: 'Medium'),
    _FlashcardGroup(title: 'Quiz 1', difficulty: 'Hard'),
  ];

  void _deleteGroup(int index) {
    setState(() {
      _groups.removeAt(index);
    });
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else if (widget.courseId != null) {
              context.go('/courses/detail/${widget.courseId}');
            } else {
              context.go('/home');
            }
          },
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
                child: _groups.isEmpty
                    ? const Center(
                  child: Text(
                    'No flashcard groups yet.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _groups.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.gapMedium),
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    return _GroupButton(
                      title: '${group.title}: ${group.difficulty}',
                      onTap: () {
                        context.push(
                          '/flashcards/questions',
                          extra: group.title,
                        );
                      },
                      onDelete: () => _deleteGroup(index),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gapMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await context.push<Map<String, String>>(
                    '/flashcards/groups/add',
                  );

                  if (result != null) {
                    setState(() {
                      _groups.add(
                        _FlashcardGroup(
                          title: result['title'] ?? 'New Group',
                          difficulty: result['difficulty'] ?? 'Easy',
                        ),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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

class _FlashcardGroup {
  final String title;
  final String difficulty;

  _FlashcardGroup({required this.title, required this.difficulty});
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
                child: Text(
                  title,
                  style: AppTextStyles.listButton,
                  textAlign: TextAlign.center,
                ),
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
