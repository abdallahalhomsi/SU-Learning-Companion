import 'package:flutter/material.dart';

class DateTimeFormatter {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  /// For fake string like "15.03.2025"
  static String formatRawDate(String raw) {
    final parts = raw.split('.');
    if (parts.length != 3) return raw;

    final day = int.tryParse(parts[0]) ?? 1;
    final month = int.tryParse(parts[1]) ?? 1;
    final year = parts[2];

    final monthName = _months[month - 1];
    return '$day $monthName $year';
  }

  /// Converts "23:59" → "11:59 PM"
  static String formatRawTime(String raw) {
    final parts = raw.split(':');
    if (parts.length != 2) return raw;

    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];

    final suffix = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) hour = 12;            // 00 → 12 AM
    else if (hour > 12) hour -= 12;      // 13 → 1 PM

    return '$hour:${minute.padLeft(2, '0')} $suffix';
  }

  /// For REAL DateTime (new exams & homework)
  static String formatDateTime(DateTime dt) {
    final monthName = _months[dt.month - 1];

    int hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) hour = 12;
    else if (hour > 12) hour -= 12;

    return '${dt.day} $monthName ${dt.year}, $hour:$minute $suffix';
  }
}