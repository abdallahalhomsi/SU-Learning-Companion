import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:su_learning_companion/common/utils/app_colors.dart';
import 'package:su_learning_companion/common/utils/app_spacing.dart';
import 'package:su_learning_companion/common/utils/app_text_styles.dart';
import 'package:su_learning_companion/common/widgets/app_scaffold.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // For now we don’t load events (CoursesRepo has no getAllEvents()).
    // Later: we’ll query user homeworks/exams and render them here.
    _finishLoading();
  }

  Future<void> _finishLoading() async {
    // keep async shape in case you want to fetch later
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep Provider import so you’re ready later (and it won’t break if locator changes)
    context.read; // no-op, avoids “unused import” warnings in some setups

    return AppScaffold(
      currentIndex: 1,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        title: Text(
          'CALENDAR',
          style: AppTextStyles.appBarTitle.copyWith(letterSpacing: 1.3),
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

                // Temporary empty-state
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'No events yet. Add exams/homeworks to see them here.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
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

  Widget _buildCalendarGrid(int startingWeekday, int daysInMonth) {
    final rows = <Widget>[];
    int dayCounter = 1;

    for (int week = 0; week < 6; week++) {
      final days = <Widget>[];

      for (int weekday = 0; weekday < 7; weekday++) {
        if (week == 0 && weekday < startingWeekday) {
          days.add(_emptyDayCell());
        } else if (dayCounter <= daysInMonth) {
          final day = dayCounter;

          days.add(
            Expanded(
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 13,
                    ),
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
}
