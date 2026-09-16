import 'package:streak_calculator_flutter/core/utils/app_logger.dart';

import '../../../habits/domain/models/habit.dart';

class StreakRiskService {
  const StreakRiskService();

  Habit? find(
      List<Habit> habits,
      ) {
    for (final habit in habits) {
      AppLogger.log(
        '''
${habit.title}
currentStreak=${habit.currentStreak}
completedToday=${habit.completedToday}
archived=${habit.archived}
''',
      );
    }

    final riskyHabits = habits.where(
          (habit) {
        return habit.currentStreak > 0 &&
            !habit.completedToday &&
            !habit.archived;
      },
    );

    AppLogger.log(
      'Risky habits found: ${riskyHabits.length}',
    );

    if (riskyHabits.isEmpty) {
      return null;
    }

    return riskyHabits.first;
  }
}