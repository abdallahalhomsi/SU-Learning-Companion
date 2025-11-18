// This file makes up the components of the Flashcards Questions Screen,
// Which displays a list of flashcard questions for a specific group.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';

class FlashcardsQuestionsScreen extends StatefulWidget {
  final String groupTitle;

  const FlashcardsQuestionsScreen({
    super.key,
    required this.groupTitle,
  });

  @override
  State<FlashcardsQuestionsScreen> createState() =>
      _FlashcardsQuestionsScreenState();
}

class _FlashcardsQuestionsScreenState extends State<FlashcardsQuestionsScreen> {
  static final Map<String, List<_FlashCard>> _storage = {
    'Chapter X': [
      _FlashCard(
        question: 'Define xyz based on abc',
        answer: 'Solution: xyz is based on abc because...',
      ),
      _FlashCard(
        question: 'What is the powerhouse of the cell?',
        answer: 'Mitochondria',
      ),
    ],
  };

  List<_FlashCard> get _currentCards {
    _storage.putIfAbsent(widget.groupTitle, () => []);
    return _storage[widget.groupTitle]!;
  }

  void _deleteCard(int index) {
    setState(() {
      _currentCards.removeAt(index);
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
                child: _currentCards.isEmpty
                    ? const Center(
                  child: Text(
                    'No cards created yet.',
                    style: TextStyle(fontSize: 14),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _currentCards.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final card = _currentCards[index];
                    return _CardItem(
                      question: card.question,
                      onTap: () {
                        context.push(
                          '/flashcards/solution',
                          extra: {
                            'title': card.question,
                            'solution': card.answer,
                          },
                        );
                      },
                      onDelete: () => _deleteCard(index),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await context.push<Map<String, String>>(
                    '/flashcards/create',
                  );

                  if (result != null) {
                    setState(() {
                      _currentCards.add(
                        _FlashCard(
                          question: result['question'] ?? 'New Question',
                          answer: result['solution'] ?? 'New Answer',
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

class _FlashCard {
  final String question;
  final String answer;

  _FlashCard({
    required this.question,
    required this.answer,
  });
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
