import '../../../statistics/domain/calculators/common/streak_result.dart';
import '../models/habit.dart';
import '../services/habit_schedule_service.dart';

/// Single source of truth for recurrence-aware streak calculation.
///
/// A "streak" only advances on days the habit is actually scheduled
/// (per [HabitScheduleService]), so a weekly/monthly habit is not
/// penalized for the days in between its scheduled occurrences.
///
/// Today is still open: if today is scheduled but not completed yet,
/// the streak runs up to the previous scheduled occurrence instead of
/// dropping to 0 (it only breaks once a scheduled day has passed
/// without a completion).
///
/// This is used both to persist a habit's `currentStreak`/`bestStreak`
/// (see [StreakCalculator] in this same folder) and to power the
/// Statistics screen, so the two surfaces never disagree.
class ScheduleAwareStreakCalculator {
  const ScheduleAwareStreakCalculator();

  static const HabitScheduleService _scheduleService =
      HabitScheduleService();

  /// [completedDays] must be date-only values of COMPLETED logs.
  /// Duplicates and order do not matter.
  ///
  /// [today] defaults to the current date (injectable for tests).
  StreakResult calculate(
    Habit habit,
    List<DateTime> completedDays, {
    DateTime? today,
  }) {
    if (completedDays.isEmpty) {
      return StreakResult.empty;
    }

    final days = {for (final day in completedDays) _dateOnly(day)};
    final sortedDays = days.toList()..sort();

    final now = _dateOnly(today ?? DateTime.now());

    final longestStreak = _calculateLongestStreak(habit, sortedDays);

    // ---------------------------------------------------------
    // Anchor: the latest scheduled occurrence that counts.
    //
    // Today, if it is scheduled and already completed. If today is
    // scheduled but not completed yet, it is still open, so the
    // streak is measured up to the previous scheduled occurrence.
    // ---------------------------------------------------------

    var anchor = _latestScheduledDateOnOrBefore(habit, now);

    if (anchor != null && anchor == now && !days.contains(now)) {
      anchor = _previousScheduledDate(habit, now);
    }

    var currentStreak = 0;
    var cursor = anchor;

    while (cursor != null && days.contains(cursor)) {
      currentStreak++;
      cursor = _previousScheduledDate(habit, cursor);
    }

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak:
          longestStreak > currentStreak ? longestStreak : currentStreak,
      completedDays: sortedDays.length,
      perfectDays: sortedDays.length,
    );
  }

  // ===========================================================
  // LONGEST STREAK
  // ===========================================================

  int _calculateLongestStreak(
    Habit habit,
    List<DateTime> completedDays,
  ) {
    if (completedDays.isEmpty) {
      return 0;
    }

    int longest = 1;
    int running = 1;

    for (int i = 1; i < completedDays.length; i++) {
      final previous = completedDays[i - 1];
      final current = completedDays[i];

      final expectedNext = _nextScheduledDate(
        habit,
        previous,
      );

      if (expectedNext != null && current == expectedNext) {
        running++;

        if (running > longest) {
          longest = running;
        }
      } else {
        running = 1;
      }
    }

    return longest;
  }

  // ===========================================================
  // SCHEDULE WALKERS
  //
  // Bounded to 366 days to guarantee termination even for a
  // habit whose schedule can never match again (e.g. monthlyDay
  // that no longer exists) or whose start/end bounds are narrow.
  // ===========================================================

  DateTime? _latestScheduledDateOnOrBefore(
    Habit habit,
    DateTime date,
  ) {
    var cursor = _dateOnly(date);

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(habit, cursor)) {
        return cursor;
      }

      cursor = _addDays(cursor, -1);
    }

    return null;
  }

  DateTime? _previousScheduledDate(
    Habit habit,
    DateTime date,
  ) {
    var cursor = _addDays(_dateOnly(date), -1);

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(habit, cursor)) {
        return cursor;
      }

      cursor = _addDays(cursor, -1);
    }

    return null;
  }

  DateTime? _nextScheduledDate(
    Habit habit,
    DateTime date,
  ) {
    var cursor = _addDays(_dateOnly(date), 1);

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(habit, cursor)) {
        return cursor;
      }

      cursor = _addDays(cursor, 1);
    }

    return null;
  }

  bool _isScheduled(
    Habit habit,
    DateTime date,
  ) {
    // Streak history must survive archiving a habit, so the
    // archived flag is deliberately ignored here.
    return _scheduleService.isScheduledIgnoringArchived(
      habit,
      date,
    );
  }

  // ===========================================================
  // DATE HELPERS
  // ===========================================================

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Calendar arithmetic, not Duration: on daylight-saving change
  /// days a local day is 23 or 25 hours long, and subtracting 24 h
  /// would skip or repeat a date.
  DateTime _addDays(DateTime date, int days) {
    return DateTime(date.year, date.month, date.day + days);
  }
}
