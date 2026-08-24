import '../../../habits/domain/models/habit_log.dart';

class HabitLogBackupMapper {
  const HabitLogBackupMapper();

  Map<String, dynamic> toJson(
      HabitLog log,
      ) {
    return {
      'id': log.id,
      'habitId': log.habitId,
      'date': log.date.toIso8601String(),
      'status': log.status.name,
      'completedAt':
      log.completedAt?.toIso8601String(),
      'durationMinutes':
      log.durationMinutes,
      'notes': log.notes,
      'xpEarned': log.xpEarned,
      'mood': log.mood?.name,
    };
  }
}