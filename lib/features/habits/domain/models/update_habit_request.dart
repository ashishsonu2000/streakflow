import '../enums/habit_frequency.dart';
import 'habit_category.dart';

class UpdateHabitRequest {
  const UpdateHabitRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.iconCodePoint,
    required this.colorValue,
    required this.targetPerDay,
    required this.reminderEnabled,
    this.reminderHour,
    this.reminderMinute,

    // Schedule
    required this.startDate,
    this.endDate,

    // Recurrence
    this.weeklyDays = const <int>[],
    this.monthlyDay = 1,

    // Existing habit data
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.xp,
    required this.archived,
    required this.createdAt,
    this.lastCompletedDate,
    required this.completedToday,
  });

  final String id;

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

  final DateTime startDate;

  final DateTime? endDate;

  // =========================================================
  // Weekly Schedule
  // =========================================================

  final List<int> weeklyDays;

  // =========================================================
  // Monthly Schedule
  // =========================================================

  final int monthlyDay;

  // =========================================================
  // Existing Values
  // =========================================================

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int xp;

  final bool archived;

  final DateTime createdAt;

  final DateTime? lastCompletedDate;

  final bool completedToday;

  // =========================================================
  // Copy With
  // =========================================================

  UpdateHabitRequest copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    int? iconCodePoint,
    int? colorValue,
    int? targetPerDay,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,

    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,

    List<int>? weeklyDays,
    int? monthlyDay,

    int? currentStreak,
    int? bestStreak,
    int? totalCompleted,
    int? xp,
    bool? archived,
    DateTime? createdAt,
    DateTime? lastCompletedDate,
    bool? completedToday,
  }) {
    return UpdateHabitRequest(
      id: id ?? this.id,

      title: title ?? this.title,

      description:
      description ?? this.description,

      category:
      category ?? this.category,

      frequency:
      frequency ?? this.frequency,

      iconCodePoint:
      iconCodePoint ?? this.iconCodePoint,

      colorValue:
      colorValue ?? this.colorValue,

      targetPerDay:
      targetPerDay ?? this.targetPerDay,

      reminderEnabled:
      reminderEnabled ?? this.reminderEnabled,

      reminderHour:
      reminderHour ?? this.reminderHour,

      reminderMinute:
      reminderMinute ?? this.reminderMinute,

      // Schedule
      startDate:
      startDate ?? this.startDate,

      endDate:
      clearEndDate
          ? null
          : endDate ?? this.endDate,

      // Recurrence
      weeklyDays:
      weeklyDays ?? this.weeklyDays,

      monthlyDay:
      monthlyDay ?? this.monthlyDay,

      // Existing values
      currentStreak:
      currentStreak ?? this.currentStreak,

      bestStreak:
      bestStreak ?? this.bestStreak,

      totalCompleted:
      totalCompleted ?? this.totalCompleted,

      xp:
      xp ?? this.xp,

      archived:
      archived ?? this.archived,

      createdAt:
      createdAt ?? this.createdAt,

      lastCompletedDate:
      lastCompletedDate ??
          this.lastCompletedDate,

      completedToday:
      completedToday ?? this.completedToday,
    );
  }
}