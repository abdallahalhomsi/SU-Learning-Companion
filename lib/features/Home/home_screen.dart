// lib/features/Home/home_screen.dart
//
// Home Screen:
// - Shows reminders (dummy for now)
// - Shows USER courses from Firestore via CoursesRepo (Provider)
// - Delete removes from users/{uid}/courses
// - Uses ScrollControllers for Scrollbar (no more assertion)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:su_learning_companion/common/models/course.dart';
import 'package:su_learning_companion/common/repos/courses_repo.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CoursesRepo _coursesRepo;

  final ScrollController _remindersScroll = ScrollController();
  final ScrollController _coursesScroll = ScrollController();

  final List<Map<String, String>> _reminders = const [
    {'course': 'CS301', 'detail': 'Due Tomorrow'},
    {'course': 'CS306', 'detail': 'Due Today'},
    {'course': 'CS306', 'detail': 'Due Next Week'},
    {'course': 'CS310', 'detail': 'Due Friday'},
  ];

  bool _repoReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_repoReady) {
      _coursesRepo = context.read<CoursesRepo>(); // ✅ Firestore repo from Provider
      _repoReady = true;
    }
  }

  @override
  void dispose() {
    _remindersScroll.dispose();
    _coursesScroll.dispose();
    super.dispose();
  }

  Future<void> _deleteCourse(String courseId) async {
    try {
      await _coursesRepo.removeUserCourse(courseId); // ✅ remove from user collection
      if (!mounted) return;
      setState(() {
        // triggers FutureBuilder again
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar with logo + add course button
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
                    onPressed: () => context.go('/courses/add'),
                    child: const Text(
                      '+ ADD COURSE',
                      style: AppTextStyles.primaryButton,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reminders (scrollable + scrollbar)
                  SizedBox(
                    height: 170,
                    child: Scrollbar(
                      controller: _remindersScroll,
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(12),
                      child: ListView.separated(
                        controller: _remindersScroll,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = _reminders[index];
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

                  // "YOUR COURSES" box
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
                          future: _coursesRepo.getCourses(), // ✅ user courses
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white70),
                              );
                            }

                            final courses = snapshot.data ?? [];
                            if (courses.isEmpty) {
                              return const Text(
                                'No courses yet',
                                style: TextStyle(color: Colors.white70),
                              );
                            }

                            return Scrollbar(
                              controller: _coursesScroll,
                              thumbVisibility: true,
                              thickness: 5,
                              radius: const Radius.circular(12),
                              child: ListView(
                                controller: _coursesScroll,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: courses.map((course) {
                                  return _CourseRow(
                                    code: course.code,
                                    onTap: () {
                                      context.go('/courses/detail/${course.id}');
                                    },
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete ${course.code}?'),
                                            content: const Text(
                                              'Are you sure you want to remove this course?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await _deleteCourse(course.id);
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
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

      // Bottom nav bar
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
  final VoidCallback? onDelete;

  const _CourseRow({
    required this.code,
    required this.onTap,
    this.onDelete,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chevron_right, color: Colors.white70),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
