// This file makes up the components of the Calendar Screen,
// Which includes a custom calendar view displaying events for the next six months.
// Uses of Utility classes for consistent styling and spacing across the app.
// Custom fonts are being used.


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import '../../common/models/course.dart';
import '../../common/repos/courses_repo.dart';
import '../../data/fakes/fake_courses_repo.dart';
import '../../common/widgets/app_scaffold.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CoursesRepo _coursesRepo = FakeCoursesRepo();
  List<CourseEvent> _allEvents = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    final events = await _coursesRepo.getAllEvents();
    setState(() {
      _allEvents = events;
      _isLoading = false;
    });
  }

  List<CourseEvent> _getEventsForDay(DateTime day) {
    final dayEvents = <CourseEvent>[];
    for (var event in _allEvents) {
      if (event.dueDate.year == day.year &&
          event.dueDate.month == day.month &&
          event.dueDate.day == day.day) {
        dayEvents.add(event);
      }
    }
    return dayEvents;
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
          style: AppTextStyles.appBarTitle.copyWith(
            letterSpacing: 1.3,
          ),
        ),
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
    final lastDayOfMonth =
        DateTime(displayMonth.year, displayMonth.month + 1, 0);
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
      children: weekdays.map((day) {
        return Expanded(
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
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(
      int startingWeekday, int daysInMonth, DateTime displayMonth) {
    final rows = <Widget>[];
    int dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      final days = <Widget>[];

      for (int weekday = 0; weekday < 7; weekday++) {
        if (week == 0 && weekday < startingWeekday) {
          
          days.add(
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: const SizedBox(height: 36),
              ),
            ),
          );
        } else if (dayCounter <= daysInMonth) {
          final day = dayCounter;
          final date = DateTime(displayMonth.year, displayMonth.month, day);
          final hasEvents = _getEventsForDay(date).isNotEmpty;

          days.add(
            Expanded(
              child: GestureDetector(
                onTap: hasEvents ? () => _showDayEvents(date) : null,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasEvents
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
                      if (hasEvents)
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
          
          days.add(
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: const SizedBox(height: 36),
              ),
            ),
          );
        }
      }

      rows.add(Row(children: days));
      if (dayCounter > daysInMonth) break;
    }

    return Column(children: rows);
  }

  void _showDayEvents(DateTime date) {
    final dayEvents = _getEventsForDay(date);
    if (dayEvents.isEmpty) return;

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

              
              ...dayEvents.map((event) {
                Color eventColor;
                switch (event.type) {
                  case CourseEventType.exam:
                    eventColor = Colors.red;
                    break;
                  case CourseEventType.homework:
                    eventColor = Colors.blue;
                    break;
                  case CourseEventType.deadline:
                    eventColor = Colors.orange;
                    break;
                  case CourseEventType.quiz:
                    eventColor = Colors.green;
                    break;
                }

                return Container(
                  margin:
                      const EdgeInsets.only(bottom: AppSpacing.gapMedium),
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
                          color: eventColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.type.displayName,
                              style: TextStyle(
                                fontSize: 14,
                                color: eventColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (event.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                event.description!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(event.dueDate),
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
