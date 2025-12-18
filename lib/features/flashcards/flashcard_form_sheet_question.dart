// lib/features/flashcards/flashcard_form_sheet_question.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/models/flashcard.dart';
import '../../common/repos/flashcards_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';

/// A form screen that allows users to add a specific Question & Answer card
/// to an existing Flashcard Group.
class FlashcardFormSheetQuestion extends StatefulWidget {
  final String courseId;
  final String groupId;

  const FlashcardFormSheetQuestion({
    super.key,
    required this.courseId,
    required this.groupId,
  });

  @override
  State<FlashcardFormSheetQuestion> createState() =>
      _FlashcardFormSheetQuestionState();
}

class _FlashcardFormSheetQuestionState
    extends State<FlashcardFormSheetQuestion> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String? _selectedDifficulty;

  late final FlashcardsRepo _repo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repo = context.read<FlashcardsRepo>();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  /// Validates the form and persists the new Flashcard to Firestore.
  Future<void> _submit() async {
    final formValid = _formKey.currentState!.validate();
    final difficultyValid = _selectedDifficulty != null;

    if (!formValid || !difficultyValid) {
      _showErrorDialog();
      return;
    }

    // Create Flashcard Object
    // ID and UserID are empty here; the Repository layer handles generation and security.
    final newCard = Flashcard(
      id: '',
      courseId: widget.courseId,
      groupId: widget.groupId,
      question: _questionController.text.trim(),
      solution: _answerController.text.trim(),
      difficulty: _selectedDifficulty!,
      createdAt: DateTime.now(),
      userId: '',
    );

    try {
      await _repo.addFlashcard(newCard);

      if (!mounted) return;
      context.pop(); // Close screen on success
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving card: $e')),
      );
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please fix the form'),
        content: const Text(
          'Some fields are missing or invalid.\n'
              'Fields with red text need your attention.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        title: const Text(
          'Create Flashcard',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        _buildFieldWrapper(
                          height: 80,
                          child: TextFormField(
                            controller: _questionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Question',
                              errorStyle: AppTextStyles.errorText,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Question is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildFieldWrapper(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text('Select Difficulty'),
                              value: _selectedDifficulty,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Easy', child: Text('Easy')),
                                DropdownMenuItem(
                                    value: 'Medium', child: Text('Medium')),
                                DropdownMenuItem(
                                    value: 'Hard', child: Text('Hard')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedDifficulty = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildFieldWrapper(
                          height: 100,
                          child: TextFormField(
                            controller: _answerController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Answer...',
                              errorStyle: AppTextStyles.errorText,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Answer is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: AppTextStyles.primaryButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldWrapper({required Widget child, double height = 44}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.inputGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}