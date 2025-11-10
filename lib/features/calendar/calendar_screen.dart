import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _loadEvents();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text(
          'CALENDAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Show 6 months
            ..._buildMonthCalendars(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: const Color(0xFF003366),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
            // Already on calendar
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMonthCalendars() {
    final now = DateTime.now();
    final widgets = <Widget>[];

    // Generate 6 months starting from current month
    for (int i = 0; i < 6; i++) {
      final displayMonth = DateTime(now.year, now.month + i, 1);
      widgets.add(_buildSingleMonth(displayMonth));
      widgets.add(const SizedBox(height: 16));
    }

    return widgets;
  }

  Widget _buildSingleMonth(DateTime displayMonth) {
    final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDayOfMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Month header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            DateFormat('MMMM yyyy').format(displayMonth),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003366),
            ),
          ),
        ),
        // Calendar grid
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF003366),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildWeekdayHeaders(),
              const SizedBox(height: 8),
              _buildCalendarGrid(startingWeekday, lastDayOfMonth.day, displayMonth),
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
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(int startingWeekday, int daysInMonth, DateTime displayMonth) {
    final rows = <Widget>[];
    int dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      final days = <Widget>[];

      for (int weekday = 0; weekday < 7; weekday++) {
        if (week == 0 && weekday < startingWeekday) {
          days.add(Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
              ),
              child: const SizedBox(height: 36),
            ),
          ));
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
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '$day',
                          style: const TextStyle(
                            color: Colors.white,
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
          days.add(Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
              ),
              child: const SizedBox(height: 36),
            ),
          ));
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
            color: Colors.white,
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003366),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                  margin: const EdgeInsets.only(bottom: 12),
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF003366),
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
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(event.dueDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
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