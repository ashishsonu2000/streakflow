import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';

class StatisticsInput {
  const StatisticsInput({
    required this.habits,
    required this.logs,
  });

  final List<Habit> habits;

  final List<HabitLog> logs;
}
