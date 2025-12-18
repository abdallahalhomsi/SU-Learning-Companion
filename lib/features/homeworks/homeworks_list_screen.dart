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

class HomeworksListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;

  const HomeworksListScreen({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<HomeworksRepo>();

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
          onPressed: () => context.go('/courses/detail/$courseId'),
        ),
        title: Text(
          'Homeworks: $courseName',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),

      // 🔥 REAL-TIME UI
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

                // ⭐ STREAM BUILDER
                child: StreamBuilder<List<Homework>>(
                  stream: repo.watchHomeworksForCourse(courseId),
                  builder: (context, snapshot) {
                    // First load (no cached data yet)
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load homeworks',
                          style: AppTextStyles.errorText,
                        ),
                      );
                    }

                    final homeworks = snapshot.data ?? [];

                    if (homeworks.isEmpty) {
                      return const Center(
                        child: Text(
                          'No homeworks yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: homeworks.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.gapSmall),
                      itemBuilder: (context, index) {
                        final hw = homeworks[index];

                        final formattedDate =
                        DateTimeFormatter.formatRawDate(hw.date);
                        final formattedTime =
                        DateTimeFormatter.formatRawTime(hw.time);

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
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 12),
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
                                onPressed: () {
                                  repo.removeHomework(courseId, hw.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
                    '/courses/$courseId/homeworks/add',
                    extra: {'courseName': courseName},
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
