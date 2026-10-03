import 'package:flutter/material.dart';

import '../../../../core/ui/icons/habit_icon_resolver.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';
import '../models/activity_item.dart';
import '../models/activity_status.dart';

class ActivityMapper {
  const ActivityMapper();

  /// How many completions Recent Activity shows.
  static const int recentLimit = 10;

  /// The latest [recentLimit] completions. [habits] should include
  /// every habit (also ones not due today, and archived ones) so each
  /// completion shows its habit's name.
  List<ActivityItem> map({
    required List<Habit> habits,
    required List<HabitLog> logs,
  }) {
    final habitMap = {
      for (final h in habits) h.id: h,
    };

    return logs.map((log) {
      final habit = habitMap[log.habitId];

      return ActivityItem(
        id: log.id,
        title: habit?.title ?? "Habit",
        description: "Completed",
        icon: habitIconFromCodePoint(
          habit?.iconCodePoint ?? Icons.check.codePoint,
        ),
        color: Color(habit?.colorValue ?? 0xFF4CAF50),
        status: ActivityStatus.completed,
        // When the completion was recorded; logs without it fall back
        // to their own date (not "now", which showed "Just now").
        date: log.completedAt ?? log.date,
        xp: log.xpEarned,
        time: "",
      );
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date)) // latest first
      ..length = logs.length < recentLimit ? logs.length : recentLimit;
  }
}