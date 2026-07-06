import '../../data/entities/habit_frequency.dart';
import 'habit_category.dart';

class Habit {
  final String id;

  final String title;

  final String description;

  final HabitCategory category;

  final HabitFrequency frequency;

  final int iconCodePoint;

  final int colorValue;

  final int targetPerDay;

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int xp;

  final bool reminderEnabled;

  final int? reminderHour;

  final int? reminderMinute;

  final bool archived;

  final DateTime createdAt;

  final DateTime updatedAt;

  final DateTime? lastCompletedDate;

  final bool completedToday;

  const Habit({
    required this.id,
    required this.title,
    this.description = '',
    this.category = HabitCategory.personal,
    this.frequency = HabitFrequency.daily,
    this.iconCodePoint = 0,
    this.colorValue = 0,
    this.targetPerDay = 1,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalCompleted = 0,
    this.xp = 0,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
    this.archived = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastCompletedDate,
    this.completedToday = false,
  });

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    int? iconCodePoint,
    int? colorValue,
    int? targetPerDay,
    int? currentStreak,
    int? bestStreak,
    int? totalCompleted,
    int? xp,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastCompletedDate,
    bool? completedToday,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      xp: xp ?? this.xp,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      completedToday: completedToday ?? this.completedToday,
    );
  }
}
