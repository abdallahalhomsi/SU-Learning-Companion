// lib/features/Home/home_screen.dart
//
// Home Screen:
// - Reminders: pulls this user's Exams + Homeworks for CURRENT MONTH
// - Shows USER courses from Firestore via CoursesRepo (providers)
// - Faster: caches courses Future + loads reminders in parallel
// - UI: "YOUR COURSES" title at top of box + smaller gaps

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:su_learning_companion/common/models/course.dart';

import 'package:su_learning_companion/common/repos/courses_repo.dart';
import 'package:su_learning_companion/common/repos/exams_repo.dart';
import 'package:su_learning_companion/common/repos/homeworks_repo.dart';

import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';

import 'package:su_learning_companion/common/widgets/app_scaffold.dart';

enum _ReminderType { exam, homework }

class _Reminder {
  final _ReminderType type;
  final String courseId;
  final String courseCode;
  final String title;
  final DateTime dueDate;

  const _Reminder({
    required this.type,
    required this.courseId,
    required this.courseCode,
    required this.title,
    required this.dueDate,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CoursesRepo _coursesRepo;
  late final ExamsRepo _examsRepo;
  late final HomeworksRepo _homeworksRepo;

  final ScrollController _remindersScroll = ScrollController();
  final ScrollController _coursesScroll = ScrollController();

  bool _reposReady = false;

  // ✅ cache courses future so we don't refetch on every build
  Future<List<Course>>? _coursesFuture;

  bool _remindersLoading = true;
  List<_Reminder> _reminders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reposReady) return;

    _coursesRepo = context.read<CoursesRepo>();
    _examsRepo = context.read<ExamsRepo>();
    _homeworksRepo = context.read<HomeworksRepo>();
    _reposReady = true;

    _coursesFuture = _coursesRepo.getCourses();
    _loadRemindersForThisMonth(); // will reuse courses
  }

  @override
  void dispose() {
    _remindersScroll.dispose();
    _coursesScroll.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    setState(() {
      _coursesFuture = _coursesRepo.getCourses();
      _remindersLoading = true;
    });
    await _loadRemindersForThisMonth();
  }

  Future<void> _deleteCourse(String courseId) async {
    try {
      await _coursesRepo.removeUserCourse(courseId);
      if (!mounted) return;

      // Refresh courses + reminders
      await _refreshAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete course: $e')),
      );
    }
  }

  Future<void> _loadRemindersForThisMonth() async {
    setState(() => _remindersLoading = true);

    try {
      final now = DateTime.now();

      // ✅ reuse cached courses if available, otherwise fetch once
      final courses = await (_coursesFuture ?? _coursesRepo.getCourses());
      final codeById = {for (final c in courses) c.id: c.code};

      // ✅ parallel fetch: for each course fetch exams + hws concurrently
      final futures = courses.map((c) async {
        final results = await Future.wait([
          _examsRepo.getExamsForCourse(c.id),
          _homeworksRepo.getHomeworksForCourse(c.id),
        ]);

        final exams = results[0] as List<dynamic>;
        final hws = results[1] as List<dynamic>;

        final list = <_Reminder>[];

        for (final e in exams) {
          final dt = _parseDateTime(e.date, e.time);
          if (dt == null) continue;
          if (dt.year == now.year && dt.month == now.month) {
            list.add(
              _Reminder(
                type: _ReminderType.exam,
                courseId: c.id,
                courseCode: codeById[c.id] ?? c.code,
                title: e.title,
                dueDate: dt,
              ),
            );
          }
        }

        for (final h in hws) {
          final dt = _parseDateTime(h.date, h.time);
          if (dt == null) continue;
          if (dt.year == now.year && dt.month == now.month) {
            list.add(
              _Reminder(
                type: _ReminderType.homework,
                courseId: c.id,
                courseCode: codeById[c.id] ?? c.code,
                title: h.title,
                dueDate: dt,
              ),
            );
          }
        }

        return list;
      }).toList();

      final nested = await Future.wait(futures);
      final items = <_Reminder>[];
      for (final sub in nested) {
        items.addAll(sub);
      }

      // soonest first
      items.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      if (!mounted) return;
      setState(() {
        _reminders = items;
        _remindersLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _remindersLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reminders: $e')),
      );
    }
  }

  // date: "10 Mar 2025" OR "2025-03-10" OR "10.03.2025"
  // time: "09:05" OR "9:05" OR "9:05 AM"
  DateTime? _parseDateTime(String dateStr, String timeStr) {
    final d = dateStr.trim();
    final t = timeStr.trim();

    DateTime? date;
    for (final fmt in <DateFormat>[
      DateFormat('d MMM yyyy'),
      DateFormat('dd MMM yyyy'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd.MM.yyyy'),
      DateFormat('d.M.yyyy'),
    ]) {
      try {
        date = fmt.parseStrict(d);
        break;
      } catch (_) {}
    }
    if (date == null) return null;

    try {
      final parsed = DateFormat('h:mm a').parseStrict(t);
      return DateTime(date.year, date.month, date.day, parsed.hour, parsed.minute);
    } catch (_) {}

    try {
      final parsed = DateFormat('H:mm').parseStrict(t);
      return DateTime(date.year, date.month, date.day, parsed.hour, parsed.minute);
    } catch (_) {}

    final parts = t.split(':');
    final h = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
    final m = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (h != null) {
      return DateTime(date.year, date.month, date.day, h, m ?? 0);
    }

    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top bar
            Container(
              color: Theme.of(context).colorScheme.surface,
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
                    child: const Text('+ ADD COURSE', style: AppTextStyles.primaryButton),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // REMINDERS (this month)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'THIS MONTH',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: .4,
                        ),
                      ),
                      IconButton(
                        onPressed: _refreshAll,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Divider(color: Colors.white24, height: 10),
                  const SizedBox(height: 0),

                  SizedBox(
                    height: 170,
                    child: _remindersLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _reminders.isEmpty
                        ? Center(
                      child: Text(
                        'No exams/homeworks this month',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                        : Scrollbar(
                      controller: _remindersScroll,
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(12),
                      child: ListView.separated(
                        controller: _remindersScroll,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _reminders.length,
                        itemBuilder: (context, index) {
                          final r = _reminders[index];

                          final isExam = r.type == _ReminderType.exam;
                          final icon = isExam ? Icons.assignment : Icons.description;
                          final iconColor = isExam ? Colors.redAccent : Colors.blueAccent;

                          final when = DateFormat('MMM d • h:mm a').format(r.dueDate);
                          final typeLabel = isExam ? 'Exam' : 'Homework';

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(
                              leading: Icon(icon, color: iconColor),
                              title: Text(
                                '${r.courseCode} • ${r.title}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text('$typeLabel • $when'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.go('/courses/detail/${r.courseId}'),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.gapSmall),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // YOUR COURSES (UI FIX + faster fetch)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // ✅ was top padding 60 -> makes title sit low. Now it's tight.
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                        const SizedBox(height: 6),
                        const Divider(color: Colors.white24, height: 10),
                        const SizedBox(height: 6),

                        FutureBuilder<List<Course>>(
                          future: _coursesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(12),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
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
                              child: ListView.builder(
                                controller: _coursesScroll,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero, // ✅ THIS REMOVES THE GAP
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: courses.length,
                                itemBuilder: (context, i) {
                                  final course = courses[i];
                                  return _CourseRow(
                                    code: course.code,
                                    onTap: () => context.go('/courses/detail/${course.id}'),
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete ${course.code}?'),
                                          content: const Text('Are you sure you want to remove this course?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await _deleteCourse(course.id);
                                              },
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
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
      minVerticalPadding: 0,                // ✅ remove extra vertical padding
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(   // ✅ tighter overall tile height
        horizontal: 0,
        vertical: -4,
      ),
      leading: const Icon(
        Icons.star_border,
        color: AppColors.textOnPrimary,
        size: 22,                           // ✅ slightly smaller
      ),
      title: Text(
        code,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 14,                     // ✅ slightly smaller to reduce height
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
          IconButton(
            padding: EdgeInsets.zero,       // ✅ remove IconButton padding
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
