// This file makes up the components of the Detailed Course Features Screen,
// Which provides navigation to various features related to a specific course.
// The features include Notes, Resources, Flashcards, Homeworks, and Exams.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used. 


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../common/widgets/app_scaffold.dart';

class DetailedCourseFeaturesScreen extends StatefulWidget {
  final String courseId;

  const DetailedCourseFeaturesScreen({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<DetailedCourseFeaturesScreen> createState() =>
      _DetailedCourseFeaturesScreenState();
}

class _DetailedCourseFeaturesScreenState
    extends State<DetailedCourseFeaturesScreen> {
  final CoursesRepo _coursesRepo = FakeCoursesRepo();
  Course? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    setState(() => _isLoading = true);
    final course = await _coursesRepo.getCourseById(widget.courseId);
    setState(() {
      _course = course;
      _isLoading = false;
    });
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
            context.go('/home');
          },
        ),
        centerTitle: true,
        title: Text(
          _course?.name ?? 'Course Name',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _course == null
              ? Center(
                  child: Text(
                    'Course not found',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 60,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFeatureButton(
                          icon: Icons.note,
                          label: 'Notes',
                          onTap: () {
                            context.go(
                              '/courses/${widget.courseId}/notes',
                              extra: {
                                'courseName': _course?.name ?? 'Course',
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.gapMedium * 3),

                        _buildFeatureButton(
                          icon: Icons.folder,
                          label: 'Resources',
                          onTap: () {
                            context.go(
                              '/courses/${widget.courseId}/resources',
                              extra: {
                                'courseName': _course?.name ?? 'Course',
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.gapMedium * 3),

                        _buildFeatureButton(
                          icon: Icons.style,
                          label: 'Flashcards',
                          onTap: () {
                            context.push(
                              '/flashcards',
                              extra: {
                                'courseId': widget.courseId,
                                'courseName': _course?.name ?? 'Course',
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.gapMedium * 3),

                        _buildFeatureButton(
                          icon: Icons.assignment,
                          label: 'Homeworks',
                          onTap: () {
                            context.go(
                              '/courses/${widget.courseId}/homeworks',
                              extra: {
                                'courseName': _course?.name ?? 'Course',
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.gapMedium * 3),

                        _buildFeatureButton(
                          icon: Icons.quiz,
                          label: 'Exams',
                          onTap: () {
                            context.go(
                              '/courses/${widget.courseId}/exams',
                              extra: {
                                'courseName': _course?.name ?? 'Course',
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textOnPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.listButton.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text(
          '$feature feature for ${_course?.name}\n\nComing soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
