// This file makes up the components of the Exams List Screen,
// Which displays a list of exams for a specific course.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/date_time_formatter.dart';
import '../../common/models/exam.dart';
import '../../common/repos/exams_repo.dart';
import '../../data/fakes/fake_exams_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_spacing.dart';
import '../../common/utils/app_text_styles.dart';

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
  final ExamsRepo _examsRepo = FakeExamsRepo();

  List<Exam> _exams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  void _loadExams() {
    final items = _examsRepo.getExamsForCourse(widget.courseId);
    setState(() {
      _exams = items;
      _isLoading = false;
    });
  }

  void _removeExam(String examId) {
    _examsRepo.removeExam(examId);
    _loadExams();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
          onPressed: () {
            context.go('/courses/detail/${widget.courseId}');
          },
        ),
        title: Text(
          'Exams: ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
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
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _exams.isEmpty
                      ? const Center(child: Text('No exams yet'))
                      : ListView.separated(
                    itemCount: _exams.length,
                    itemBuilder: (context, index) {
                      final exam = _exams[index];

                      final formattedDate =
                      DateTimeFormatter.formatRawDate(exam.date);
                      final formattedTime =
                      DateTimeFormatter.formatRawTime(exam.time);

                      return Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 12),
                              child: Text(
                                '${exam.title}: $formattedDate, $formattedTime',
                                style: const TextStyle(
                                  color: AppColors.textOnPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.textOnPrimary,
                              ),
                              onPressed: () {
                                _removeExam(exam.id);
                              },
                            ),
                          ],
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
                  child: const Text(
                    '+ Add Exam',
                    style: AppTextStyles.primaryButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
