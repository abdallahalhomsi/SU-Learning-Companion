import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';

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
  // Static list for persistence
  static final List<_FlashcardGroup> _groups = [
    _FlashcardGroup(title: 'Chapter X', difficulty: 'Easy'),
    _FlashcardGroup(title: 'Lecture Slides Y', difficulty: 'Medium'),
    _FlashcardGroup(title: 'Quiz 1', difficulty: 'Hard'),
  ];

  //Immediate Delete (No Confirmation Dialog)
  void _deleteGroup(int index) {
    setState(() {
      _groups.removeAt(index);
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          style: const TextStyle(
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
                child: _groups.isEmpty
                    ? const Center(child: Text("No flashcard groups yet."))
                    : ListView.separated(
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
                      onDelete: () => _deleteGroup(index),
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
    const Color primaryBlue = Color(0xFF003366);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: primaryBlue,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
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