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

  /// [logs] must be COMPLETED logs only.
  StreakResult calculate(
      List<HabitLog> logs, {
        Habit? habit,
        DateTime? today,
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
        today: today,
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
      today: today,
    );
  }

  // ===========================================================
  // CALENDAR-DAY CALCULATION (no single habit, e.g. the overview)
  //
  // A day counts when it has at least one log in [logs] - callers
  // pass COMPLETED logs only. Today is still open: the current
  // streak runs through today or, if today has no completion yet,
  // through yesterday. An older run is history, not a current streak.
  // ===========================================================

  StreakResult _calculateCalendarStreak(
      List<DateTime> uniqueDays, {
      DateTime? today,
      }) {
    final days = {for (final day in uniqueDays) _dayNumber(day)};
    final sorted = days.toList()..sort();

    final todayNumber = _dayNumber(today ?? DateTime.now());

    // ---------------------------------------------------------
    // Current streak
    // ---------------------------------------------------------

    var cursor = days.contains(todayNumber) ? todayNumber : todayNumber - 1;
    var currentStreak = 0;

    while (days.contains(cursor)) {
      currentStreak++;
      cursor--;
    }

    // ---------------------------------------------------------
    // Longest streak
    // ---------------------------------------------------------

    var longestStreak = 1;
    var running = 1;

    for (var i = 1; i < sorted.length; i++) {
      if (sorted[i] - sorted[i - 1] == 1) {
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
      completedDays: sorted.length,
      perfectDays: sorted.length,
    );
  }

  /// Days since the epoch for a local calendar date. Comparing day
  /// numbers (not local midnights) keeps daylight-saving days, which
  /// are 23 or 25 hours long, from breaking "consecutive day" checks.
  int _dayNumber(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day)
          .millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

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