import '../../../statistics/domain/calculators/common/streak_result.dart';
import '../../data/entities/habit_log_entity.dart';
import '../enums/completion_status.dart';
import '../models/habit.dart';
import 'schedule_aware_streak_calculator.dart';

class StreakCalculator {
  const StreakCalculator._();

  static const ScheduleAwareStreakCalculator _scheduleAwareCalculator =
      ScheduleAwareStreakCalculator();

  /// Calculates streak/completion stats from a habit's logs.
  ///
  /// When [habit] is provided, the streak is recurrence-aware: a
  /// weekly/monthly habit only needs to be completed on its scheduled
  /// days to keep its streak alive. This keeps the persisted
  /// `currentStreak`/`bestStreak` shown on the dashboard consistent
  /// with the Statistics screen, which uses the same calculation.
  ///
  /// When [habit] is omitted, every calendar day is treated as
  /// scheduled (legacy daily-only behavior).
  static StreakResult calculate(
      List<HabitLogEntity> logs, {
        DateTime? startDate,
        DateTime? endDate,
        Habit? habit,
      }) {
    if (habit != null) {
      final completedDays = logs
          .where(
            (log) => log.status == CompletionStatus.completed,
          )
          .map((log) => _dateOnly(log.date))
          .toSet()
          .toList();

      return _scheduleAwareCalculator.calculate(
        habit,
        completedDays,
      );
    }

    // =========================================================
    // Normalize schedule dates
    // =========================================================

    final normalizedStartDate =
    startDate == null
        ? null
        : _dateOnly(startDate);

    final normalizedEndDate =
    endDate == null
        ? null
        : _dateOnly(endDate);

    // Invalid schedule.
    if (normalizedStartDate != null &&
        normalizedEndDate != null &&
        normalizedEndDate.isBefore(
          normalizedStartDate,
        )) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        completedDays: 0,
        perfectDays: 0,
      );
    }

    // =========================================================
    // Filter completed logs
    // =========================================================

    final completedLogs = logs.where(
          (log) {
        if (log.status !=
            CompletionStatus.completed) {
          return false;
        }

        final day = _dateOnly(log.date);

        // Before habit start.
        if (normalizedStartDate != null &&
            day.isBefore(
              normalizedStartDate,
            )) {
          return false;
        }

        // After habit end.
        if (normalizedEndDate != null &&
            day.isAfter(
              normalizedEndDate,
            )) {
          return false;
        }

        return true;
      },
    ).toList();

    if (completedLogs.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        completedDays: 0,
        perfectDays: 0,
      );
    }

    // =========================================================
    // Unique completed days
    // =========================================================

    final uniqueDays = completedLogs
        .map(
          (log) => _dateOnly(log.date),
    )
        .toSet()
        .toList()
      ..sort(
            (a, b) => b.compareTo(a),
      );

    final completedDays =
        uniqueDays.length;

    // Phase 1 supports daily recurrence,
    // so completed days are the current
    // "perfect" days metric.
    final perfectDays =
        completedDays;

    // =========================================================
    // Current Streak
    // =========================================================

    final currentStreak =
    _calculateCurrentStreak(
      uniqueDays,
      startDate: normalizedStartDate,
      endDate: normalizedEndDate,
    );

    // =========================================================
    // Longest Streak
    // =========================================================

    final longestStreak =
    _calculateLongestStreak(
      uniqueDays,
    );

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      completedDays: completedDays,
      perfectDays: perfectDays,
    );
  }

  // =========================================================
  // Current Streak
  // =========================================================

  static int _calculateCurrentStreak(
      List<DateTime> uniqueDays, {
        DateTime? startDate,
        DateTime? endDate,
      }) {
    if (uniqueDays.isEmpty) {
      return 0;
    }

    final today =
    _dateOnly(DateTime.now());

    // If the habit hasn't started yet,
    // there cannot be a current streak.
    if (startDate != null &&
        today.isBefore(startDate)) {
      return 0;
    }

    // Determine the date from which the
    // current streak should be evaluated.
    //
    // Ongoing habit:
    //     today
    //
    // Ended habit:
    //     endDate
    //
    var anchorDate = today;

    if (endDate != null &&
        endDate.isBefore(anchorDate)) {
      anchorDate = endDate;
    }

    if (startDate != null &&
        anchorDate.isBefore(startDate)) {
      return 0;
    }

    // ---------------------------------------------------------
    // Find the first completed day.
    //
    // If today/anchor is not completed, yesterday is allowed
    // because the user may not have completed today's habit yet.
    // ---------------------------------------------------------

    DateTime? expectedDate;

    if (uniqueDays.contains(anchorDate)) {
      expectedDate = anchorDate;
    } else {
      final previousDay =
      anchorDate.subtract(
        const Duration(days: 1),
      );

      if (startDate != null &&
          previousDay.isBefore(startDate)) {
        return 0;
      }

      if (uniqueDays.contains(previousDay)) {
        expectedDate = previousDay;
      } else {
        return 0;
      }
    }

    // ---------------------------------------------------------
    // Walk backwards through consecutive days.
    // ---------------------------------------------------------

    var currentStreak = 0;

    while (expectedDate != null) {
      if (!uniqueDays.contains(
        expectedDate,
      )) {
        break;
      }

      // Don't go before the habit start date.
      if (startDate != null &&
          expectedDate.isBefore(startDate)) {
        break;
      }

      // Don't go after the habit end date.
      if (endDate != null &&
          expectedDate.isAfter(endDate)) {
        break;
      }

      currentStreak++;

      expectedDate =
          expectedDate.subtract(
            const Duration(days: 1),
          );
    }

    return currentStreak;
  }

  // =========================================================
  // Longest Streak
  // =========================================================

  static int _calculateLongestStreak(
      List<DateTime> uniqueDays,
      ) {
    if (uniqueDays.isEmpty) {
      return 0;
    }

    var longest = 1;
    var running = 1;

    for (var i = 1;
    i < uniqueDays.length;
    i++) {
      final previous =
      uniqueDays[i - 1];

      final current =
      uniqueDays[i];

      if (previous
          .difference(current)
          .inDays ==
          1) {
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

  // =========================================================
  // Date Helper
  // =========================================================

  static DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}