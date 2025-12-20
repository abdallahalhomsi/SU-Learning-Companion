import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_scaffold.dart';
import '../../common/utils/date_time_formatter.dart';
import '../../common/models/homework.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_spacing.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/providers/homeworks_provider.dart';

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
  bool _bound = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bound) {
      _bound = true;
      context.read<HomeworksProvider>().bindCourse(widget.courseId);
    }
  }

  Future<void> _removeHomework(String homeworkId) async {
    try {
      await context.read<HomeworksProvider>().remove(widget.courseId, homeworkId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove homework: $e')),
      );
    }
  }

  Future<void> _openEdit(Homework hw) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => HomeworkEditScreen(courseName: widget.courseName, homework: hw),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeworksProvider>();
    final items = provider.items;
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
        title: Text('Homeworks: ${widget.courseName}', style: AppTextStyles.appBarTitle),
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
                      : items.isEmpty
                      ? Center(
                    child: Text(
                      'No homeworks yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                      : ListView.separated(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final hw = items[index];

                      final formattedDate =
                      DateTimeFormatter.formatRawDate(hw.date);
                      final formattedTime =
                      DateTimeFormatter.formatRawTime(hw.time);

                      return InkWell(
                        onTap: () => _openEdit(hw),
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
                                icon: const Icon(Icons.delete,
                                    color: AppColors.textOnPrimary),
                                onPressed: () => _removeHomework(hw.id),
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
                      '/courses/${widget.courseId}/homeworks/add',
                      extra: {'courseName': widget.courseName},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('+ Add Homework', style: AppTextStyles.primaryButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
