// This file makes up the components of the Add Homeworks Screen,
// Which displays a form for the user to add a homework for a specific course.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/models/homework.dart';
import '../../common/repos/homeworks_repo.dart';
import '../../data/fakes/fake_homeworks_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class HomeworkFormScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const HomeworkFormScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<HomeworkFormScreen> createState() => _HomeworkFormScreenState();
}

class _HomeworkFormScreenState extends State<HomeworkFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final HomeworksRepo _homeworksRepo = FakeHomeworksRepo();

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
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        final months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;

        int displayHour =
        picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
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

    final storedDate = _dateController.text.trim();
    final storedTime =
        '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    final homework = Homework(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: widget.courseId,
      title: _titleController.text.trim(),
      date: storedDate,
      time: storedTime,
    );

    _homeworksRepo.addHomework(homework);

    if (!mounted) return;
    context.go(
      '/courses/${widget.courseId}/homeworks',
      extra: {'courseName': widget.courseName},
    );
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
              '/courses/${widget.courseId}/homeworks',
              extra: {'courseName': widget.courseName},
            );
          },
        ),
        title: const Text(
          'Add Homework',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: AppSpacing.card,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
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
                      const SizedBox(height: AppSpacing.gapSmall),
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Date...',
                            errorStyle: AppTextStyles.errorText,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Date is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gapSmall),
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: _pickTime,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Time',
                            errorStyle: AppTextStyles.errorText,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Time is required';
                            }
                            return null;
                          },
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
