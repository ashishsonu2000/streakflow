import '../../../habits/domain/enums/mood_type.dart';

class DayHabitViewModel {
  const DayHabitViewModel({
    required this.id,
    required this.title,
    required this.completed,
    required this.completedAt,
    required this.durationMinutes,
    required this.xpEarned,
    required this.notes,
    required this.mood,
  });

  final String id;

  final String title;

  final bool completed;

  final DateTime? completedAt;

  final int durationMinutes;

  final int xpEarned;

  final String notes;

  final MoodType? mood;
}
