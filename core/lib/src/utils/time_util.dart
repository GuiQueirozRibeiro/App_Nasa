// External packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {
  const TimeUtil._();

  static String _formatter(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static String getStartDate({required DateTime date}) {
    final weekAgo = date.subtract(const Duration(days: 6));
    return _formatter(weekAgo);
  }

  static String getEndDate({required DateTime date}) {
    return _formatter(date);
  }

  static String formatDate(Locale locale, DateTime date) {
    final format = DateFormat.yMd(locale.toString());
    return format.format(date);
  }

  static bool containsDateString(DateTime date, String query) {
    String dateString = _formatter(date);
    return dateString.contains(query);
  }
}
