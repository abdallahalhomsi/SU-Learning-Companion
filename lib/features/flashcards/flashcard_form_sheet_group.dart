// This file makes up the components of the Flashcards FormSheet Groups Screen
// Which displays a form for creating new groups inside a topic
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';

class FlashcardFormSheetGroup extends StatefulWidget {
  const FlashcardFormSheetGroup({super.key});

  @override
  State<FlashcardFormSheetGroup> createState() =>
      _FlashcardFormSheetGroupState();
}

class _FlashcardFormSheetGroupState extends State<FlashcardFormSheetGroup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String? _selectedDifficulty;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _selectedDifficulty == null) {
      _showErrorDialog();
      return;
    }

    Navigator.of(context).pop(<String, String>{
      'title': _titleController.text.trim(),
      'difficulty': _selectedDifficulty!,
    });
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
          'Add Flashcard Group',
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            errorStyle: AppTextStyles.errorText,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFieldWrapper(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Select Difficulty'),
                            value: _selectedDifficulty,
                            items: const [
                              DropdownMenuItem(
                                value: 'Easy',
                                child: Text('Easy'),
                              ),
                              DropdownMenuItem(
                                value: 'Medium',
                                child: Text('Medium'),
                              ),
                              DropdownMenuItem(
                                value: 'Hard',
                                child: Text('Hard'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDifficulty = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildFieldWrapper({required Widget child}) {
    return Container(
      height: 44,
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
