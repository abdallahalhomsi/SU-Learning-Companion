import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';

class FlashcardsQuestionsScreen extends StatefulWidget {
  final String groupTitle; // e.g. "Chapter X"

  const FlashcardsQuestionsScreen({
    super.key,
    required this.groupTitle,
  });

  @override
  State<FlashcardsQuestionsScreen> createState() =>
      _FlashcardsQuestionsScreenState();
}

class _FlashcardsQuestionsScreenState
    extends State<FlashcardsQuestionsScreen> {
  final List<_FlashcardQuestion> _questions = [
    const _FlashcardQuestion(
      title: 'Card 1: Define xyz based on abc',
      solution:
      'Solution for Card 1: xyz is based on abc because ... (sample text).',
    ),
    const _FlashcardQuestion(
      title: 'Card 2: Define xyz based on abc',
      solution:
      'Solution for Card 2: xyz is based on abc because ... (sample text).',
    ),
    const _FlashcardQuestion(
      title: 'Card 3: Define xyz based on abc',
      solution:
      'Solution for Card 3: xyz is based on abc because ... (sample text).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Flash Cards : ${widget.groupTitle}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final q = _questions[index];
                  return _QuestionCard(
                    title: q.title,
                    onTap: () {
                      context.push(
                        '/flashcards/solution',
                        extra: {
                          'title': q.title,
                          'solution': q.solution,
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                  await context.push<Map<String, String>>(
                    '/flashcards/create',
                  );

                  if (result != null && result['title'] != null) {
                    setState(() {
                      _questions.add(
                        _FlashcardQuestion(
                          title: result['title']!,
                          solution: result['solution'] ?? '',
                        ),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '+ Create Flash Card',
                  style: TextStyle(
                    color: Colors.white,
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

class _FlashcardQuestion {
  final String title;
  final String solution;

  const _FlashcardQuestion({
    required this.title,
    required this.solution,
  });
}

class _QuestionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _QuestionCard({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to reveal answer',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
