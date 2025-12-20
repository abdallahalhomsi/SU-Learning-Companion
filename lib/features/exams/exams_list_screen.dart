import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/date_time_formatter.dart';
import '../../common/models/exam.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_spacing.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/providers/exams_provider.dart';

import 'exam_edit_screen.dart';

class ExamsListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const ExamsListScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<ExamsListScreen> createState() => _ExamsListScreenState();
}

class _ExamsListScreenState extends State<ExamsListScreen> {
  bool _bound = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bound) {
      _bound = true;
      context.read<ExamsProvider>().bindCourse(widget.courseId);
    }
  }

  Future<void> _removeExam(String examId) async {
    try {
      await context.read<ExamsProvider>().remove(widget.courseId, examId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove exam: $e')),
      );
    }
  }

  Future<void> _openEdit(Exam exam) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ExamEditScreen(courseName: widget.courseName, exam: exam),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamsProvider>();
    final exams = provider.items;
    final isLoading = provider.isLoading;
    final error = provider.error;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).colorScheme.surface;

    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textOnPrimary, size: 20),
          onPressed: () => context.go('/courses/detail/${widget.courseId}'),
        ),
        title: Text('Exams: ${widget.courseName}', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: AppSpacing.card,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (error != null)
                      ? Center(child: Text('Error: $error'))
                      : exams.isEmpty
                      ? Center(
                    child: Text(
                      'No exams yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                      : ListView.separated(
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      final exam = exams[index];
                      final formattedDate =
                      DateTimeFormatter.formatRawDate(exam.date);
                      final formattedTime =
                      DateTimeFormatter.formatRawTime(exam.time);

                      return InkWell(
                        onTap: () => _openEdit(exam),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    '${exam.title}: $formattedDate, $formattedTime',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textOnPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppColors.textOnPrimary),
                                onPressed: () => _removeExam(exam.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.gapSmall),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.gapMedium),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(
                      '/courses/${widget.courseId}/exams/add',
                      extra: {'courseName': widget.courseName},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('+ Add Exam', style: AppTextStyles.primaryButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
