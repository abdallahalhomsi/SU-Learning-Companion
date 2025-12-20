// lib/features/flashcards/flashcards_questions_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';

import '../../common/models/flashcard.dart';
import '../../common/repos/flashcards_repo.dart';

class FlashcardsQuestionsScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String groupId;
  final String groupTitle;

  const FlashcardsQuestionsScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.groupId,
    required this.groupTitle,
  });

  @override
  State<FlashcardsQuestionsScreen> createState() =>
      _FlashcardsQuestionsScreenState();
}

class _FlashcardsQuestionsScreenState extends State<FlashcardsQuestionsScreen> {
  late final FlashcardsRepo _repo;
  bool _repoReady = false;

  late Future<List<Flashcard>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _repo = context.read<FlashcardsRepo>();
      _repoReady = true;
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _future = _repo.getFlashcards(widget.courseId, widget.groupId);
    });
  }

  Future<void> _deleteCard(Flashcard card) async {
    try {
      await _repo.deleteFlashcard(
        widget.courseId,
        widget.groupId,
        card.id,
      );
      if (!mounted) return;
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete card: $e')),
      );
    }
  }


  Future<void> _addCard() async {
    await context.push('/flashcards/create', extra: {
      'courseId': widget.courseId,
      'groupId': widget.groupId,
    });


    if (!mounted) return;
    _loadData();
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
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Flashcards: ${widget.groupTitle}',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: FutureBuilder<List<Flashcard>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final cards = snapshot.data ?? [];
                    if (cards.isEmpty) {
                      return const Center(
                        child: Text(
                          'No cards created yet.',
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cards.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return _CardItem(
                          question: card.question,
                          onTap: () {
                            context.push(
                              '/flashcards/solution',
                              extra: {
                                'title': card.question,
                                'solution': card.solution
                              },
                            );
                          },
                          onDelete: () => _deleteCard(card),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '+ Create Flash Card',
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


class _CardItem extends StatelessWidget {
  final String question;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CardItem({
    required this.question,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    question,
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
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