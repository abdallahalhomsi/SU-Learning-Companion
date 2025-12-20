import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/models/exam.dart';
import '../../common/repos/exams_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_spacing.dart';
import '../../common/utils/app_text_styles.dart';

class ExamFormScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ExamFormScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<ExamFormScreen> createState() => _ExamFormScreenState();
}

class _ExamFormScreenState extends State<ExamFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  late final ExamsRepo _examsRepo;
  bool _repoReady = false;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _fieldBg => _isDark ? const Color(0xFF111827) : AppColors.inputGrey;
  Color get _fieldText => _isDark ? Colors.white : Colors.black;
  Color get _hintText => _isDark ? Colors.white70 : Colors.black54;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _examsRepo = context.read<ExamsRepo>();
      _repoReady = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(primary: AppColors.primaryBlue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        final months = [
          'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
        ];
        _dateController.text =
        '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(primary: AppColors.primaryBlue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;

        int displayHour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        final minute = picked.minute.toString().padLeft(2, '0');
        final suffix = picked.period == DayPeriod.am ? 'AM' : 'PM';

        _timeController.text = '$displayHour:$minute $suffix';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
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
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both date and time'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must login first.')),
      );
      return;
    }

    final storedDate = _dateController.text.trim();
    final storedTime =
        '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    final exam = Exam(
      id: '',
      courseId: widget.courseId,
      title: _titleController.text.trim(),
      date: storedDate,
      time: storedTime,

      // ✅ required fields
      createdBy: user.uid,
      createdAt: DateTime.now(),
    );

    try {
      await _examsRepo.addExam(exam);
      if (!mounted) return;
      context.go(
        '/courses/${widget.courseId}/exams',
        extra: {'courseName': widget.courseName},
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add exam: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textOnPrimary, size: 20),
          onPressed: () {
            context.go(
              '/courses/${widget.courseId}/exams',
              extra: {'courseName': widget.courseName},
            );
          },
        ),
        title: const Text('Add Exam', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSpacing.screen,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: AppSpacing.card,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(color: _hintText),
                            errorStyle: AppTextStyles.errorText,
                          ),
                          validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Title is required'
                              : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gapSmall),
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _pickDate,
                          style: TextStyle(color: _fieldText),
                          cursorColor: _fieldText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Date...',
                            hintStyle: TextStyle(color: _hintText),
                            errorStyle: AppTextStyles.errorText,
                          ),
                          validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Date is required'
                              : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gapSmall),
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: _pickTime,
                          style: TextStyle(color: _fieldText),
                          cursorColor: _fieldText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Time',
                            hintStyle: TextStyle(color: _hintText),
                            errorStyle: AppTextStyles.errorText,
                          ),
                          validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Time is required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gapMedium),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _submit,
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
        border: Border.all(
          color: _isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
