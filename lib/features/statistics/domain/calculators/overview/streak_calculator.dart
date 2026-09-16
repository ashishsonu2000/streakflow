import '../../../../habits/domain/calculators/schedule_aware_streak_calculator.dart';
import '../../../../habits/domain/models/habit.dart';
import '../../../../habits/domain/models/habit_log.dart';
import '../common/streak_result.dart';


class StreakCalculator {
  const StreakCalculator();

  static const ScheduleAwareStreakCalculator _scheduleAwareCalculator =
      ScheduleAwareStreakCalculator();

  // ===========================================================
  // EXISTING API
  //
  // Keeps all existing callers working:
  //
  // StreakCalculator().calculate(logs)
  //
  // This is used by overview/performance calculations where
  // a single Habit is not available.
  // ===========================================================

  StreakResult calculate(
      List<HabitLog> logs, {
        Habit? habit,
      }) {
    if (logs.isEmpty) {
      return StreakResult.empty;
    }

    final uniqueDays = logs
        .map(
          (log) => _dateOnly(log.date),
    )
        .toSet()
        .toList()
      ..sort();

    if (uniqueDays.isEmpty) {
      return StreakResult.empty;
    }

    // =========================================================
    // Without a habit:
    //
    // Preserve the original calendar-day streak behavior.
    // =========================================================

    if (habit == null) {
      return _calculateCalendarStreak(
        uniqueDays,
      );
    }

    // =========================================================
    // With a habit:
    //
    // Use the shared recurrence-aware streak calculator so this
    // screen never disagrees with the persisted habit streak.
    // =========================================================

    return _scheduleAwareCalculator.calculate(
      habit,
      uniqueDays,
    );
  }

  // ===========================================================
  // ORIGINAL CALENDAR-DAY CALCULATION
  // ===========================================================

  StreakResult _calculateCalendarStreak(
      List<DateTime> uniqueDays,
      ) {
    final today = _dateOnly(
      DateTime.now(),
    );

    // ---------------------------------------------------------
    // Current streak
    // ---------------------------------------------------------

    int currentStreak = 0;

    DateTime expectedDay;

    if (uniqueDays.last == today) {
      expectedDay = today;
    } else if (uniqueDays.last ==
        today.subtract(
          const Duration(days: 1),
        )) {
      expectedDay = today.subtract(
        const Duration(days: 1),
      );
    } else {
      expectedDay = uniqueDays.last;
    }

    for (
    int i = uniqueDays.length - 1;
    i >= 0;
    i--
    ) {
      if (uniqueDays[i] == expectedDay) {
        currentStreak++;

        expectedDay = expectedDay.subtract(
          const Duration(days: 1),
        );
      } else {
        break;
      }
    }

    // ---------------------------------------------------------
    // Longest streak
    // ---------------------------------------------------------

    int longestStreak = 1;
    int running = 1;

    for (
    int i = 1;
    i < uniqueDays.length;
    i++
    ) {
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

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      completedDays: uniqueDays.length,
      perfectDays: uniqueDays.length,
    );
  }

  // ===========================================================
  // DATE HELPERS
  // ===========================================================

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}