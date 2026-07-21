// features/habits/domain/models/update_habit_request.dart

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

    // Existing habit data to preserve
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

  /// Existing values that must not be lost during update.
  final int currentStreak;
  final int bestStreak;
  final int totalCompleted;
  final int xp;

  final bool archived;

  final DateTime createdAt;

  final DateTime? lastCompletedDate;

  final bool completedToday;

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
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      xp: xp ?? this.xp,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      completedToday: completedToday ?? this.completedToday,
    );
  }
}
