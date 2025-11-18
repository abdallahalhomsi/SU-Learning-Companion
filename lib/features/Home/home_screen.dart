// This file makes up the components of the Home Screen,
// Which displays the main page of the app, courses registred, and an add course feature.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/app_text_styles.dart';
import '../../common/utils/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> reminders = [
      {'course': 'CS301', 'detail': 'Due Tomorrow'},
      {'course': 'CS306', 'detail': 'Due Today'},
      {'course': 'CS306', 'detail': 'Due Next Week'},
      {'course': 'CS310', 'detail': 'Due Friday'},
    ];

    final CoursesRepo coursesRepo = FakeCoursesRepo();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.cardBackground,
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 55,
                    child: Image.asset(
                      'lib/common/assets/sabanci_logo.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      context.go('/courses/add');
                    },
                    child: const Text(
                      '+ ADD COURSE',
                      style: AppTextStyles.primaryButton,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 170,
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(12),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = reminders[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.info_outline,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                reminder['course']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(reminder['detail']!),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.gapSmall),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR COURSES',
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .6,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.gapSmall),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: AppSpacing.gapSmall),

                        FutureBuilder<List<Course>>(
                          future: coursesRepo.getCourses(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text(
                                'No courses yet',
                                style: TextStyle(color: Colors.white70),
                              );
                            }

                            final courses = snapshot.data!;

                            return Column(
                              children: courses.map((course) {
                                return _CourseRow(
                                  code: course.code,
                                  onTap: () {
                                    context.go(
                                      '/courses/detail/${course.id}',
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppColors.primaryBlue,
        selectedItemColor: AppColors.textOnPrimary,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class _CourseRow extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const _CourseRow({
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.star_border, color: AppColors.textOnPrimary),
      title: Text(
        code,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
      const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
