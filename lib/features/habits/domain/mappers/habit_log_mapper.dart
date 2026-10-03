import '../../data/entities/habit_log_entity.dart';
import '../../domain/models/habit_log.dart';

class HabitLogMapper {
  const HabitLogMapper();

  HabitLog toDomain(HabitLogEntity entity) {
    return HabitLog(
      id: entity.id.toString(),
      habitId: entity.habitId,
      date: entity.date,
      status: entity.status,
      completedAt: entity.completedAt,
      durationMinutes: entity.durationMinutes,
      notes: entity.notes,
      xpEarned: entity.xpEarned,
      mood: entity.mood,
    );
  }
}
