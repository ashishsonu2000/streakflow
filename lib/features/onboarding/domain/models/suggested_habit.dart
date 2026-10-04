import 'package:flutter/widgets.dart';

import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/models/habit_category.dart';

/// A ready-made habit offered during onboarding for a chosen goal.
@immutable
class SuggestedHabit {
  const SuggestedHabit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.colorValue,
    this.frequency = HabitFrequency.daily,
    this.weeklyDays = const <int>[],
    this.durationMinutes = 15,
  });

  /// Stable key, used to remember which suggestions are selected.
  final String id;

  final String title;

  final String description;

  final HabitCategory category;

  /// Must be resolvable by habitIconFromCodePoint.
  final IconData icon;

  final int colorValue;

  final HabitFrequency frequency;

  /// For weekly habits: DateTime.monday (1) .. DateTime.sunday (7).
  final List<int> weeklyDays;

  final int durationMinutes;

  /// "Daily" or the weekdays, e.g. "Sun".
  String get scheduleLabel {
    if (frequency != HabitFrequency.weekly || weeklyDays.isEmpty) {
      return 'Daily';
    }

    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weeklyDays.map((day) => names[day - 1]).join(', ');
  }
}
