import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';

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
    if (!_storage.containsKey(widget.groupTitle)) {
      _storage[widget.groupTitle] = [];
    }
    return _storage[widget.groupTitle]!;
  }

  void _deleteCard(int index) {
    setState(() {
      _currentCards.removeAt(index);
    });
  }

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Flash Cards : ${widget.groupTitle}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _currentCards.isEmpty
                    ? const Center(child: Text("No cards created yet."))
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _currentCards.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _CardItem(
                      question: _currentCards[index].question,
                      onTap: () {
                        // FIX: Pass the actual question as the 'title'
                        context.push(
                          '/flashcards/solution',
                          extra: {
                            'title': _currentCards[index].question,
                            'solution': _currentCards[index].answer,
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
                      //Add new card using just question and solution
                      _currentCards.add(_FlashCard(
                        question: result['question'] ?? 'New Question',
                        answer: result['solution'] ?? 'New Answer',
                      ));
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

class _FlashCard {
  final String question;
  final String answer;

  _FlashCard({required this.question, required this.answer});
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
    const Color primaryBlue = Color(0xFF003366);

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}