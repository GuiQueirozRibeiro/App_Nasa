import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {
  static String getStartDate({DateTime? date}) {
    final effectivedate = date ?? DateTime.now();
    final weekAgo = effectivedate.subtract(const Duration(days: 6));
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(weekAgo);
  }

  static String getEndDate({DateTime? date}) {
    final effectivedate = date ?? DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(effectivedate);
  }

  static String formatDate(Locale locale, DateTime date) {
    final format = DateFormat.yMd(locale.toString());
    return format.format(date);
  }

  static bool containsDateString(DateTime date, String query) {
    String dateString = DateFormat('dd/MM/yyyy').format(date);
    return dateString.contains(query);
  }
}
