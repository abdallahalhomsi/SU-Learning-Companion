import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _suBlueDark = Color(0xFF0D3B66);

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
      backgroundColor: const Color(0xFFF8FAFD),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar with logo + add course button
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // smaller logo + a bit lower
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
                      backgroundColor: const Color(0xFF1F7ACF),
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
                      style: TextStyle(color: Colors.white),
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
                  // Reminders list
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
                              title: Text(reminder['course']!),
                              subtitle: Text(reminder['detail']!),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                      ),
                    ),
                  ),

                  // more spacing between reminders and "YOUR COURSES"
                  const SizedBox(height: 32),

                  // "YOUR COURSES" section (from FakeCoursesRepo)
                  Container(
                    decoration: BoxDecoration(
                      color: _suBlueDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR COURSES',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 8),

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

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: _suBlueDark,
        selectedItemColor: Colors.white,
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
      leading: const Icon(Icons.star_border, color: Colors.white),
      title: Text(
        code,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
