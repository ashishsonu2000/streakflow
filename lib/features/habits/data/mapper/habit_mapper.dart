import '../../domain/models/habit.dart';

import '../entities/habit_entity.dart';

class HabitMapper {
  const HabitMapper();

  Habit toDomain(HabitEntity entity) {
    return Habit(
      id: entity.uuid,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      frequency: entity.frequency,
      iconCodePoint: entity.iconCodePoint,
      colorValue: entity.colorValue,
      targetPerDay: entity.targetPerDay,
      currentStreak: entity.currentStreak,
      bestStreak: entity.bestStreak,
      totalCompleted: entity.totalCompleted,
      xp: entity.xp,
      reminderEnabled: entity.reminderEnabled,
      reminderHour: entity.reminderHour,
      reminderMinute: entity.reminderMinute,
      archived: entity.archived,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastCompletedDate: entity.lastCompletedDate,
      completedToday: entity.completedToday,
    );
  }

  HabitEntity toEntity(Habit habit) {
    final entity = HabitEntity();

    entity.uuid = habit.id;
    entity.title = habit.title;
    entity.description = habit.description;
    entity.category = habit.category;
    entity.frequency = habit.frequency;
    entity.iconCodePoint = habit.iconCodePoint;
    entity.colorValue = habit.colorValue;
    entity.targetPerDay = habit.targetPerDay;
    entity.currentStreak = habit.currentStreak;
    entity.bestStreak = habit.bestStreak;
    entity.totalCompleted = habit.totalCompleted;
    entity.xp = habit.xp;
    entity.reminderEnabled = habit.reminderEnabled;
    entity.reminderHour = habit.reminderHour;
    entity.reminderMinute = habit.reminderMinute;
    entity.archived = habit.archived;
    entity.createdAt = habit.createdAt;
    entity.updatedAt = habit.updatedAt;
    entity.lastCompletedDate = habit.lastCompletedDate;
    entity.completedToday = habit.completedToday;
    return entity;
  }
}
