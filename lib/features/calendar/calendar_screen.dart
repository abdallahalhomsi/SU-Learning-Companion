// lib/features/calendar/calendar_screen.dart


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:su_learning_companion/common/widgets/app_scaffold.dart';

import 'package:su_learning_companion/common/models/course.dart';
import 'package:su_learning_companion/common/models/exam.dart';
import 'package:su_learning_companion/common/models/homework.dart';

import 'package:su_learning_companion/common/repos/courses_repo.dart';
import 'package:su_learning_companion/common/repos/exams_repo.dart';
import 'package:su_learning_companion/common/repos/homeworks_repo.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

enum _CalendarItemType { exam, homework }

class _CalendarItem {
  final _CalendarItemType type;
  final String courseId;
  final String courseCode;
  final String title;
  final DateTime dueDate;


  final String? rawDate;
  final String? rawTime;

  const _CalendarItem({
    required this.type,
    required this.courseId,
    required this.courseCode,
    required this.title,
    required this.dueDate,
    this.rawDate,
    this.rawTime,
  });
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CoursesRepo _coursesRepo;
  late final ExamsRepo _examsRepo;
  late final HomeworksRepo _homeworksRepo;

  bool _reposReady = false;

  bool _isLoading = true;
  List<_CalendarItem> _items = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reposReady) return;

    _coursesRepo = context.read<CoursesRepo>();
    _examsRepo = context.read<ExamsRepo>();
    _homeworksRepo = context.read<HomeworksRepo>();
    _reposReady = true;

    _loadCalendarItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCalendarItems() async {
    setState(() => _isLoading = true);

    try {

      final courses = await _coursesRepo.getCourses();
      final courseCodeById = {for (final c in courses) c.id: c.code};

      final allItems = <_CalendarItem>[];


      for (final course in courses) {
        final exams = await _examsRepo.getExamsForCourse(course.id);
        for (final e in exams) {
          final dt = _parseDateTime(e.date, e.time);
          if (dt == null) continue;
          allItems.add(
            _CalendarItem(
              type: _CalendarItemType.exam,
              courseId: course.id,
              courseCode: courseCodeById[course.id] ?? course.code,
              title: e.title,
              dueDate: dt,
              rawDate: e.date,
              rawTime: e.time,
            ),
          );
        }


        final hws = await _homeworksRepo.getHomeworksForCourse(course.id);
        for (final h in hws) {
          final dt = _parseDateTime(h.date, h.time);
          if (dt == null) continue;
          allItems.add(
            _CalendarItem(
              type: _CalendarItemType.homework,
              courseId: course.id,
              courseCode: courseCodeById[course.id] ?? course.code,
              title: h.title,
              dueDate: dt,
              rawDate: h.date,
              rawTime: h.time,
            ),
          );
        }
      }


      allItems.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      if (!mounted) return;
      setState(() {
        _items = allItems;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load calendar: $e')),
      );
    }
  }


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


    int hour = 0;
    int minute = 0;


    try {
      final parsed = DateFormat('h:mm a').parseStrict(t);
      hour = parsed.hour;
      minute = parsed.minute;
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (_) {}


    try {
      final parsed = DateFormat('H:mm').parseStrict(t);
      hour = parsed.hour;
      minute = parsed.minute;
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (_) {}


    final parts = t.split(':');
    if (parts.isNotEmpty) {
      final h = int.tryParse(parts[0]);
      final m = parts.length > 1 ? int.tryParse(parts[1]) : 0;
      if (h != null) {
        return DateTime(date.year, date.month, date.day, h, m ?? 0);
      }
    }

    return DateTime(date.year, date.month, date.day);
  }

  List<_CalendarItem> _itemsForDay(DateTime day) {
    return _items.where((it) {
      return it.dueDate.year == day.year &&
          it.dueDate.month == day.month &&
          it.dueDate.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: Text(
          'CALENDAR',
          style: AppTextStyles.appBarTitle.copyWith(letterSpacing: 1.3),
        ),
        actions: [
          IconButton(
            onPressed: _loadCalendarItems,
            icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Theme(
        data: Theme.of(context).copyWith(
          scrollbarTheme: const ScrollbarThemeData(
            thumbColor: WidgetStatePropertyAll(AppColors.primaryBlue),
            thickness: WidgetStatePropertyAll(6.0),
            radius: Radius.circular(10),
          ),
        ),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.gapMedium),
                ..._buildMonthCalendars(),
                const SizedBox(height: AppSpacing.gapMedium * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMonthCalendars() {
    final now = DateTime.now();
    final widgets = <Widget>[];

    for (int i = 0; i < 6; i++) {
      final displayMonth = DateTime(now.year, now.month + i, 1);
      widgets.add(_buildSingleMonth(displayMonth));
      widgets.add(const SizedBox(height: AppSpacing.gapMedium));
    }

    return widgets;
  }

  Widget _buildSingleMonth(DateTime displayMonth) {
    final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDayOfMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            DateFormat('MMMM yyyy').format(displayMonth),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildWeekdayHeaders(),
              const SizedBox(height: 8),
              _buildCalendarGrid(
                startingWeekday,
                lastDayOfMonth.day,
                displayMonth,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (day) => Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: AppColors.textOnPrimary.withOpacity(0.75),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildCalendarGrid(int startingWeekday, int daysInMonth, DateTime displayMonth) {
    final rows = <Widget>[];
    int dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      final days = <Widget>[];

      for (int weekday = 0; weekday < 7; weekday++) {
        if (week == 0 && weekday < startingWeekday) {
          days.add(_emptyDayCell());
        } else if (dayCounter <= daysInMonth) {
          final day = dayCounter;
          final date = DateTime(displayMonth.year, displayMonth.month, day);
          final hasItems = _itemsForDay(date).isNotEmpty;

          days.add(
            Expanded(
              child: GestureDetector(
                onTap: hasItems ? () => _showDayItems(date) : null,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasItems
                        ? AppColors.textOnPrimary.withOpacity(0.18)
                        : Colors.transparent,
                    border: Border.all(
                      color: AppColors.textOnPrimary.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '$day',
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (hasItems)
                        Positioned(
                          bottom: 3,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );

          dayCounter++;
        } else {
          days.add(_emptyDayCell());
        }
      }

      rows.add(Row(children: days));
      if (dayCounter > daysInMonth) break;
    }

    return Column(children: rows);
  }

  Widget _emptyDayCell() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textOnPrimary.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: const SizedBox(height: 36),
      ),
    );
  }

  void _showDayItems(DateTime date) {
    final dayItems = _itemsForDay(date);
    if (dayItems.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM d, yyyy').format(date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.gapMedium),

              ...dayItems.map((it) {
                final Color color = (it.type == _CalendarItemType.exam)
                    ? Colors.red
                    : Colors.blue;

                final typeLabel = (it.type == _CalendarItemType.exam)
                    ? 'Exam'
                    : 'Homework';

                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.gapMedium),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${it.courseCode} • ${it.title}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              typeLabel,
                              style: TextStyle(
                                fontSize: 14,
                                color: color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(it.dueDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
