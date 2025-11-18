// This file makes up the components of the Flashcards Solution Screen
// Which displays the solution to a flashcard question.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';

class FlashcardSolutionScreen extends StatelessWidget {
  final String cardTitle;
  final String solutionText;

  const FlashcardSolutionScreen({
    super.key,
    required this.cardTitle,
    required this.solutionText,
  });

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
        title: const Text(
          'Solution Card',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(minHeight: 80),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  cardTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      solutionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
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
