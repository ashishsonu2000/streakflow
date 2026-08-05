import '../../../statistics/domain/calculators/common/streak_result.dart';
import '../../data/entities/habit_log_entity.dart';

class StreakCalculator {
  const StreakCalculator._();

  static StreakResult calculate(
    List<HabitLogEntity> logs,
  ) {
    if (logs.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        completedDays: 0,
        perfectDays: 0,
      );
    }

    final sorted = [...logs]..sort(
        (a, b) => b.date.compareTo(a.date),
      );

    final uniqueDays = sorted
        .map(
          (e) => DateTime(
            e.date.year,
            e.date.month,
            e.date.day,
          ),
        )
        .toSet()
        .toList()
      ..sort(
        (a, b) => b.compareTo(a),
      );

    final completedDays = uniqueDays.length;
    final perfectDays = completedDays;

    //------------------------------------------
    // Current Streak
    //------------------------------------------

    var current = 0;

    final today = DateTime.now();
    var expected = DateTime(
      today.year,
      today.month,
      today.day,
    );

    for (final day in uniqueDays) {
      if (day == expected) {
        current++;
        expected = expected.subtract(
          const Duration(days: 1),
        );
      } else if (day ==
          DateTime(
            today.year,
            today.month,
            today.day - 1,
          )) {
        current++;
        expected = day.subtract(
          const Duration(days: 1),
        );
      } else {
        break;
      }
    }

    //------------------------------------------
    // Longest Streak
    //------------------------------------------

    var longest = 1;
    var running = 1;

    for (var i = 1; i < uniqueDays.length; i++) {
      final previous = uniqueDays[i - 1];
      final currentDay = uniqueDays[i];

      if (previous.difference(currentDay).inDays == 1) {
        running++;
        if (running > longest) {
          longest = running;
        }
      } else {
        running = 1;
      }
    }

    return StreakResult(
      currentStreak: current,
      longestStreak: longest,
      completedDays: completedDays,
      perfectDays: perfectDays,
    );
  }
}
