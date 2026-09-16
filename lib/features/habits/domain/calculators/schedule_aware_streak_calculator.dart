import '../../../statistics/domain/calculators/common/streak_result.dart';
import '../models/habit.dart';
import '../services/habit_schedule_service.dart';

/// Single source of truth for recurrence-aware streak calculation.
///
/// A "streak" only advances on days the habit is actually scheduled
/// (per [HabitScheduleService]), so a weekly/monthly habit is not
/// penalized for the days in between its scheduled occurrences.
///
/// This is used both to persist a habit's `currentStreak`/`bestStreak`
/// (see [StreakCalculator] in this same folder) and to power the
/// Statistics screen, so the two surfaces never disagree.
class ScheduleAwareStreakCalculator {
  const ScheduleAwareStreakCalculator();

  static const HabitScheduleService _scheduleService =
      HabitScheduleService();

  /// [completedDays] must be unique, date-only values. Order does not
  /// matter; it is sorted internally.
  StreakResult calculate(
    Habit habit,
    List<DateTime> completedDays,
  ) {
    if (completedDays.isEmpty) {
      return StreakResult.empty;
    }

    final sortedDays = List<DateTime>.of(completedDays)..sort();

    final today = _dateOnly(DateTime.now());

    // ---------------------------------------------------------
    // Find latest scheduled occurrence on or before today.
    // ---------------------------------------------------------

    final latestScheduledDate = _latestScheduledDateOnOrBefore(
      habit,
      today,
    );

    final longestStreak = _calculateLongestStreak(
      habit,
      sortedDays,
    );

    // No scheduled occurrence at all, or the latest scheduled
    // occurrence has not been completed: no current streak.
    if (latestScheduledDate == null ||
        sortedDays.last != latestScheduledDate) {
      return StreakResult(
        currentStreak: 0,
        longestStreak: longestStreak,
        completedDays: sortedDays.length,
        perfectDays: sortedDays.length,
      );
    }

    // ---------------------------------------------------------
    // Current streak: walk backwards through scheduled
    // occurrences while each one is completed.
    // ---------------------------------------------------------

    var currentStreak = 0;
    var cursor = latestScheduledDate;

    while (_containsDate(sortedDays, cursor)) {
      currentStreak++;

      final previousScheduled = _previousScheduledDate(
        habit,
        cursor,
      );

      if (previousScheduled == null) {
        break;
      }

      cursor = previousScheduled;
    }

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
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

      cursor = cursor.subtract(const Duration(days: 1));
    }

    return null;
  }

  DateTime? _previousScheduledDate(
    Habit habit,
    DateTime date,
  ) {
    var cursor = _dateOnly(date).subtract(const Duration(days: 1));

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(habit, cursor)) {
        return cursor;
      }

      cursor = cursor.subtract(const Duration(days: 1));
    }

    return null;
  }

  DateTime? _nextScheduledDate(
    Habit habit,
    DateTime date,
  ) {
    var cursor = _dateOnly(date).add(const Duration(days: 1));

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(habit, cursor)) {
        return cursor;
      }

      cursor = cursor.add(const Duration(days: 1));
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

  bool _containsDate(
    List<DateTime> dates,
    DateTime target,
  ) {
    return dates.contains(_dateOnly(target));
  }
}
