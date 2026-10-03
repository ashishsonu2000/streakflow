import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';

import 'statistics_context.dart';

class StatisticsContextFactory {
  const StatisticsContextFactory();

  StatisticsContext create({
    required List<Habit> habits,
    required List<HabitLog> logs,
    DateTime? selectedDate,
  }) {
    return StatisticsContext(
      habits: habits,
      logs: logs,
      selectedDate: selectedDate ?? DateTime.now(),
    );
  }
}