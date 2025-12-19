// lib/features/homeworks/homeworks_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/utils/date_time_formatter.dart';
import '../../common/models/homework.dart';
import '../../common/repos/homeworks_repo.dart';
import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';
import 'homework_edit_screen.dart';

class HomeworksListScreen extends StatefulWidget {
  final String courseId;
  final String courseName;

  const HomeworksListScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<HomeworksListScreen> createState() => _HomeworksListScreenState();
}

class _HomeworksListScreenState extends State<HomeworksListScreen> {
  late final HomeworksRepo _homeworksRepo;
  bool _repoReady = false;

  List<Homework> _homeworks = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _homeworksRepo = context.read<HomeworksRepo>();
      _repoReady = true;
      _loadHomeworks();
    }
  }

  Future<void> _loadHomeworks() async {
    setState(() => _isLoading = true);
    try {
      final items = await _homeworksRepo.getHomeworksForCourse(widget.courseId);
      if (!mounted) return;
      setState(() {
        _homeworks = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load homeworks: $e')),
      );
    }
  }

  Future<void> _removeHomework(String hwId) async {
    try {
      await _homeworksRepo.removeHomework(widget.courseId, hwId);
      await _loadHomeworks();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove homework: $e')),
      );
    }
  }

  Future<void> _openEdit(Homework hw) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkEditScreen(courseName: widget.courseName, homework: hw),
      ),
    );

    if (changed == true) {
      await _loadHomeworks();
    }
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
          onPressed: () => context.go('/courses/detail/${widget.courseId}'),
        ),
        title: Text(
          'Homeworks: ${widget.courseName}',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: AppSpacing.card,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
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
                    : _homeworks.isEmpty
                    ? const Center(
                  child: Text(
                    'No homeworks yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : ListView.separated(
                  itemCount: _homeworks.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.gapSmall),
                  itemBuilder: (context, index) {
                    final hw = _homeworks[index];

                    final formattedDate =
                    DateTimeFormatter.formatRawDate(hw.date);
                    final formattedTime =
                    DateTimeFormatter.formatRawTime(hw.time);

                    return InkWell(
                      onTap: () => _openEdit(hw), // ✅ tap to edit
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
                                  '${hw.title}: $formattedDate, $formattedTime',
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
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.textOnPrimary,
                              ),
                              onPressed: () => _removeHomework(hw.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                onPressed: () {
                  context.go(
                    '/courses/${widget.courseId}/homeworks/add',
                    extra: {'courseName': widget.courseName},
                  );
                },
                child: const Text(
                  '+ Add Homework',
                  style: AppTextStyles.primaryButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
