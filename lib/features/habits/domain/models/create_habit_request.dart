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
  // SCHEDULE
  // =========================================================

  final DateTime startDate;
  final DateTime? endDate;

  // =========================================================
  // WEEKLY
  // =========================================================

  final List<int> weeklyDays;

  // =========================================================
  // MONTHLY
  // =========================================================

  final int monthlyDay;

  const CreateHabitRequest({
    required this.title,
    this.description = '',
    this.category =
        HabitCategory.personal,
    this.frequency =
        HabitFrequency.daily,
    this.iconCodePoint = 0,
    this.colorValue = 0,
    this.targetPerDay = 1,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,

    required this.startDate,
    this.endDate,

    this.weeklyDays =
    const <int>[],

    this.monthlyDay = 1,
  });
}