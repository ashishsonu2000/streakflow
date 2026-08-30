import '../enums/habit_frequency.dart';
import 'habit_category.dart';

class CreateHabitRequest {
  final String title;

  final String description;

  final HabitCategory category;

  final HabitFrequency frequency;

  final int iconCodePoint;

  final int colorValue;

  final int targetPerDay;

  final bool reminderEnabled;

  final int? reminderHour;

  final int? reminderMinute;

  // =========================================================
  // Schedule
  // =========================================================

  /// First day of the habit.
  final DateTime startDate;

  /// Last day of the habit.
  ///
  /// null = ongoing.
  final DateTime? endDate;

  // =========================================================
  // Weekly Schedule
  // =========================================================

  /// Selected weekdays.
  ///
  /// 1 = Monday ... 7 = Sunday.
  final List<int> weeklyDays;

  // =========================================================
  // Monthly Schedule
  // =========================================================

  /// Selected day of the month.
  ///
  /// Valid values: 1-31.
  final int monthlyDay;

  const CreateHabitRequest({
    required this.title,
    this.description = '',
    this.category = HabitCategory.personal,
    this.frequency = HabitFrequency.daily,
    this.iconCodePoint = 0,
    this.colorValue = 0,
    this.targetPerDay = 1,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,

    // Schedule
    required this.startDate,
    this.endDate,

    // Recurrence
    this.weeklyDays = const <int>[],
    this.monthlyDay = 1,
  });
}