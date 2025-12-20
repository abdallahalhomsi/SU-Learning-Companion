import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/models/flashcard.dart';
import '../../common/repos/flashcards_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';

class FlashcardFormSheetGroup extends StatefulWidget {
  final String courseId;

  const FlashcardFormSheetGroup({
    super.key,
    required this.courseId,
  });

  @override
  State<FlashcardFormSheetGroup> createState() => _FlashcardFormSheetGroupState();
}

class _FlashcardFormSheetGroupState extends State<FlashcardFormSheetGroup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String? _selectedDifficulty;

  late final FlashcardsRepo _repo;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _fieldBg => _isDark ? const Color(0xFF111827) : AppColors.inputGrey;
  Color get _fieldText => _isDark ? Colors.white : Colors.black;
  Color get _hintText => _isDark ? Colors.white70 : Colors.black54;
  Color get _borderColor => _isDark ? const Color(0xFF334155) : Colors.transparent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repo = context.read<FlashcardsRepo>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDifficulty == null) {
      _showErrorDialog();
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must login first.')),
      );
      return;
    }

    final newGroup = FlashcardGroup(
      id: '',
      courseId: widget.courseId,
      title: _titleController.text.trim(),
      difficulty: _selectedDifficulty!,
      createdAt: DateTime.now(),
      createdBy: user.uid,
      userId: user.uid,
    );

    try {
      await _repo.addFlashcardGroup(newGroup);
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving group: $e')),
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

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(color: _hintText),
      errorStyle: AppTextStyles.errorText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownTextStyle = TextStyle(color: _fieldText, fontSize: 14);

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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _titleController,
                          style: TextStyle(color: _fieldText),
                          cursorColor: _fieldText,
                          decoration: _inputDecoration(hint: 'Title'),
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
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: _isDark ? const Color(0xFF0B1220) : Colors.white,
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: _isDark ? const Color(0xFF0B1220) : Colors.white,
                              hint: Text('Select Difficulty', style: TextStyle(color: _hintText)),
                              value: _selectedDifficulty,
                              style: dropdownTextStyle,
                              items: const [
                                DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                                DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedDifficulty = value);
                              },
                            ),
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
                child: const Text('Submit', style: AppTextStyles.primaryButton),
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
        color: _fieldBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _borderColor),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
