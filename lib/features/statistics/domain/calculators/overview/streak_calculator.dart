import '../../../../habits/domain/models/habit_log.dart';
import '../common/streak_result.dart';

class StreakCalculator {
  const StreakCalculator();

  StreakResult calculate(
    List<HabitLog> logs,
  ) {
    if (logs.isEmpty) {
      return StreakResult.empty;
    }

    //------------------------------------------
    // Normalize & sort dates
    //------------------------------------------

    final uniqueDays = logs
        .map(
          (log) => DateTime(
            log.date.year,
            log.date.month,
            log.date.day,
          ),
        )
        .toSet()
        .toList()
      ..sort();

    final today = _dateOnly(DateTime.now());

    //------------------------------------------
    // Current Streak
    //------------------------------------------

    int currentStreak = 0;

    // Allow streak to continue if the latest completion
    // was yesterday (user hasn't completed today's habits yet).
    DateTime expectedDay;

    if (uniqueDays.last == today) {
      expectedDay = today;
    } else if (uniqueDays.last == today.subtract(const Duration(days: 1))) {
      expectedDay = today.subtract(const Duration(days: 1));
    } else {
      expectedDay = uniqueDays.last;
    }

    for (int i = uniqueDays.length - 1; i >= 0; i--) {
      if (uniqueDays[i] == expectedDay) {
        currentStreak++;
        expectedDay = expectedDay.subtract(
          const Duration(days: 1),
        );
      } else {
        break;
      }
    }

    //------------------------------------------
    // Longest Streak
    //------------------------------------------

    int longestStreak = 1;
    int running = 1;

    for (int i = 1; i < uniqueDays.length; i++) {
      final previous = uniqueDays[i - 1];
      final current = uniqueDays[i];

      if (current.difference(previous).inDays == 1) {
        running++;

        if (running > longestStreak) {
          longestStreak = running;
        }
      } else {
        running = 1;
      }
    }

    //------------------------------------------
    // Result
    //------------------------------------------

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      completedDays: uniqueDays.length,

      // For now, perfect days == completed days.
      // Later this can be calculated using daily completion %
      perfectDays: uniqueDays.length,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}
