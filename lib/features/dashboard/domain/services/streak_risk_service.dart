import 'package:flutter/cupertino.dart';

import '../../../habits/domain/models/habit.dart';

class StreakRiskService {
  const StreakRiskService();

  Habit? find(
      List<Habit> habits,
      ) {
    for (final habit in habits) {
      debugPrint(
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

    debugPrint(
      'Risky habits found: ${riskyHabits.length}',
    );

    if (riskyHabits.isEmpty) {
      return null;
    }

    return riskyHabits.first;
  }
}