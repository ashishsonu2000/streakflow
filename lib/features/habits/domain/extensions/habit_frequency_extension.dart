import 'package:flutter/material.dart';

import '../../data/entities/habit_frequency.dart';

extension HabitFrequencyExtension on HabitFrequency {
  String get label {
    switch (this) {
      case HabitFrequency.daily:
        return "Daily";

      case HabitFrequency.weekly:
        return "Weekly";

      case HabitFrequency.monthly:
        return "Monthly";
      case HabitFrequency.custom:
        return "custome";
    }
  }

  IconData get icon {
    switch (this) {
      case HabitFrequency.daily:
        return Icons.today_rounded;

      case HabitFrequency.weekly:
        return Icons.date_range_rounded;

      case HabitFrequency.monthly:
        return Icons.calendar_month_rounded;
      case HabitFrequency.custom:
        return Icons.dashboard_customize_sharp;
    }
  }
}
