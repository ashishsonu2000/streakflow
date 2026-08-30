import '../../../../habits/domain/models/habit.dart';
import '../../../../habits/domain/models/habit_log.dart';
import '../../../../habits/domain/services/habit_schedule_service.dart';
import '../common/streak_result.dart';


class StreakCalculator {
  const StreakCalculator();

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
    // Use recurrence-aware streak calculation.
    // =========================================================

    return _calculateScheduledStreak(
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
  // SCHEDULE-AWARE CALCULATION
  // ===========================================================

  StreakResult _calculateScheduledStreak(
      Habit habit,
      List<DateTime> completedDays,
      ) {
    final today = _dateOnly(
      DateTime.now(),
    );

    // ---------------------------------------------------------
    // Find latest scheduled occurrence.
    // ---------------------------------------------------------

    final latestScheduledDate =
    _latestScheduledDateOnOrBefore(
      habit,
      today,
    );

    // No scheduled occurrence.
    if (latestScheduledDate == null) {
      return StreakResult(
        currentStreak: 0,
        longestStreak: _calculateLongestStreak(
          habit,
          completedDays,
        ),
        completedDays: completedDays.length,
        perfectDays: completedDays.length,
      );
    }

    // ---------------------------------------------------------
    // Latest scheduled occurrence isn't completed.
    // ---------------------------------------------------------

    if (completedDays.last != latestScheduledDate) {
      return StreakResult(
        currentStreak: 0,
        longestStreak: _calculateLongestStreak(
          habit,
          completedDays,
        ),
        completedDays: completedDays.length,
        perfectDays: completedDays.length,
      );
    }

    // ---------------------------------------------------------
    // Current streak
    // ---------------------------------------------------------

    int currentStreak = 0;

    var cursor = latestScheduledDate;

    while (_containsDate(
      completedDays,
      cursor,
    )) {
      currentStreak++;

      final previousScheduled =
      _previousScheduledDate(
        habit,
        cursor,
      );

      if (previousScheduled == null) {
        break;
      }

      cursor = previousScheduled;
    }

    // ---------------------------------------------------------
    // Longest streak
    // ---------------------------------------------------------

    final longestStreak =
    _calculateLongestStreak(
      habit,
      completedDays,
    );

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      completedDays: completedDays.length,
      perfectDays: completedDays.length,
    );
  }

  // ===========================================================
  // LONGEST SCHEDULED STREAK
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

    for (
    int i = 1;
    i < completedDays.length;
    i++
    ) {
      final previous = completedDays[i - 1];
      final current = completedDays[i];

      final expectedNext =
      _nextScheduledDate(
        habit,
        previous,
      );

      if (expectedNext != null &&
          current == expectedNext) {
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
  // LATEST SCHEDULED DATE
  // ===========================================================

  DateTime? _latestScheduledDateOnOrBefore(
      Habit habit,
      DateTime date,
      ) {
    var cursor = _dateOnly(date);

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(
        habit,
        cursor,
      )) {
        return cursor;
      }

      cursor = cursor.subtract(
        const Duration(days: 1),
      );
    }

    return null;
  }

  // ===========================================================
  // PREVIOUS SCHEDULED DATE
  // ===========================================================

  DateTime? _previousScheduledDate(
      Habit habit,
      DateTime date,
      ) {
    var cursor = _dateOnly(date).subtract(
      const Duration(days: 1),
    );

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(
        habit,
        cursor,
      )) {
        return cursor;
      }

      cursor = cursor.subtract(
        const Duration(days: 1),
      );
    }

    return null;
  }

  // ===========================================================
  // NEXT SCHEDULED DATE
  // ===========================================================

  DateTime? _nextScheduledDate(
      Habit habit,
      DateTime date,
      ) {
    var cursor = _dateOnly(date).add(
      const Duration(days: 1),
    );

    for (int i = 0; i <= 366; i++) {
      if (_isScheduled(
        habit,
        cursor,
      )) {
        return cursor;
      }

      cursor = cursor.add(
        const Duration(days: 1),
      );
    }

    return null;
  }

  // ===========================================================
  // SCHEDULE CHECK
  // ===========================================================

  bool _isScheduled(
      Habit habit,
      DateTime date,
      ) {
    return const HabitScheduleService()
        .isScheduledForDate(
      habit,
      date,
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

  bool _containsDate(
      List<DateTime> dates,
      DateTime target,
      ) {
    return dates.contains(
      _dateOnly(target),
    );
  }
}