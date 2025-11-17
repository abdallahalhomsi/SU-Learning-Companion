import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/models/exam.dart';
import '../../common/repos/exams_repo.dart';
import '../../data/fakes/fake_exams_repo.dart';

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

  final ExamsRepo _examsRepo = FakeExamsRepo();

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
          'Jan','Feb','Mar','Apr','May','Jun',
          'Jul','Aug','Sep','Oct','Nov','Dec'
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

        int displayHour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        final minute = picked.minute.toString().padLeft(2, '0');
        final suffix = picked.period == DayPeriod.am ? 'AM' : 'PM';

        _timeController.text = '$displayHour:$minute $suffix';
      });
    }
  }

  Future<void> _submit() async {
    // 1) validate text fields
    if (!_formKey.currentState!.validate()) {
      // smooth hint to user when something is wrong
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

    // 2) still make sure date & time were picked (extra safety)
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

    final exam = Exam(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: widget.courseId,
      title: _titleController.text.trim(),
      date: storedDate,
      time: storedTime,
    );

    _examsRepo.addExam(exam);

    if (!mounted) return;
    context.go(
      '/courses/${widget.courseId}/exams',
      extra: {'courseName': widget.courseName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            context.go(
              '/courses/${widget.courseId}/exams',
              extra: {'courseName': widget.courseName},
            );
          },
        ),
        title: const Text(
          'Add Exam',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  // live validation = smoother UX
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            errorStyle: TextStyle(
                              fontSize: 11,
                              height: 1.1,
                            ),
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
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Date...',
                            errorStyle: TextStyle(
                              fontSize: 11,
                              height: 1.1,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Date is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFieldWrapper(
                        child: TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: _pickTime,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Time',
                            errorStyle: TextStyle(
                              fontSize: 11,
                              height: 1.1,
                            ),
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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

  Widget _buildFieldWrapper({required Widget child}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}