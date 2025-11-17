import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';

class FlashcardSolutionScreen extends StatelessWidget {
  final String cardTitle;     // e.g. "Card 1: Define xyz based on abc"
  final String solutionText;  // full solution text to show

  const FlashcardSolutionScreen({
    super.key,
    required this.cardTitle,
    required this.solutionText,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);

    return AppScaffold(
      currentIndex: 0, // same as other course / flashcard pages
      appBar: AppBar(
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Solution Card X',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            // Top card with the question text
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  cardTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Large light-grey solution area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: SingleChildScrollView(
                  child: Text(
                    solutionText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
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
