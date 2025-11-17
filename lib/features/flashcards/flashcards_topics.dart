import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';

class FlashcardsTopicsScreen extends StatefulWidget {
  const FlashcardsTopicsScreen({super.key});

  @override
  State<FlashcardsTopicsScreen> createState() =>
      _FlashcardsTopicsScreenState();
}

class _FlashcardsTopicsScreenState extends State<FlashcardsTopicsScreen> {
  final List<_FlashcardGroup> _groups = [
    const _FlashcardGroup(title: 'Chapter X', difficulty: 'Difficulty'),
    const _FlashcardGroup(title: 'Lecture Slides Y', difficulty: 'Difficulty'),
    const _FlashcardGroup(title: 'Quiz 1', difficulty: 'Difficulty'),
    const _FlashcardGroup(title: 'Midterm Topics', difficulty: 'Difficulty'),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);

    return AppScaffold(
      currentIndex: 0, // course-related tab
      appBar: AppBar(
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Flash Cards : Course Name',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                  // wait for new group data from form screen
                  final result =
                  await context.push<Map<String, String>>(
                    '/flashcards/groups/add',
                  );

                  if (result != null &&
                      result['title'] != null &&
                      result['difficulty'] != null) {
                    setState(() {
                      _groups.add(
                        _FlashcardGroup(
                          title: result['title']!,
                          difficulty: result['difficulty']!,
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
                  '+ Add Flash Card Group',
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

class _FlashcardGroup {
  final String title;
  final String difficulty;

  const _FlashcardGroup({
    required this.title,
    required this.difficulty,
  });
}

class _GroupButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _GroupButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
