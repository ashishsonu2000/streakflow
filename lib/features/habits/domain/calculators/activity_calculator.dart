import 'package:flutter/material.dart';

import '../../../../core/ui/icons/habit_icon_resolver.dart';
import '../../data/entities/habit_log_entity.dart';
import '../../../dashboard/domain/models/activity_item.dart';
import '../../../dashboard/domain/models/activity_status.dart';

class ActivityCalculator {
  const ActivityCalculator._();

  static List<ActivityItem> calculate(
    List<HabitLogEntity> logs,
  ) {
    final sorted = List<HabitLogEntity>.from(logs)
      ..sort(
        (a, b) => (b.completedAt ?? b.date).compareTo(a.completedAt ?? a.date),
      );

    return sorted.take(20).map((log) {
      final habit = log.habit.value;

      return ActivityItem(
        id: log.id.toString(),
        title: habit?.title ?? "Unknown Habit",
        description: log.notes.isEmpty ? "Completed" : log.notes,
        icon: habitIconFromCodePoint( habit?.iconCodePoint ?? Icons.check.codePoint),
        color: Color(
          habit?.colorValue ?? Colors.blue.value,
        ),
        time: _timeAgo(
          log.completedAt ?? log.date,
        ),
        status: ActivityStatus.completed,
        date: log.completedAt ?? log.date,
        xp: 0,
      );
    }).toList();
  }

  static String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays == 1 ? "" : "s"} ago";
    }

    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}
