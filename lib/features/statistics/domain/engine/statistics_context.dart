import 'package:flutter/foundation.dart';

import '../../../../core/utils/date_utils.dart';

import '../../../habits/domain/enums/completion_status.dart';
import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';

class StatisticsContext {
  StatisticsContext({
    required this.habits,
    required this.logs,
    required this.selectedDate,
  }) {
    // =============================================================
    // NORMALIZE SELECTED DATE
    // =============================================================

    selectedDate = AppDateUtils.dateOnly(
      selectedDate,
    );

    // =============================================================
    // ACTIVE HABITS
    // =============================================================

    activeHabits = habits
        .where(
          (habit) => !habit.archived,
    )
        .toList(
      growable: false,
    );

    activeHabitCount =
        activeHabits.length;

    // =============================================================
    // COMPLETED LOGS
    // =============================================================

    completedLogs = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .toList(
      growable: false,
    );

    // =============================================================
    // HABIT LOOKUP
    // =============================================================

    habitLookup = {
      for (final habit in habits)
        habit.id: habit,
    };

    // =============================================================
    // LOGS BY HABIT
    // =============================================================

    logsByHabit =
    <String, List<HabitLog>>{};

    for (final log in logs) {
      logsByHabit
          .putIfAbsent(
        log.habitId,
            () => <HabitLog>[],
      )
          .add(log);
    }

    // =============================================================
    // LOGS BY DATE
    // =============================================================

    logsByDate =
    <DateTime, List<HabitLog>>{};

    for (final log in logs) {
      final day =
      AppDateUtils.dateOnly(
        log.date,
      );

      logsByDate
          .putIfAbsent(
        day,
            () => <HabitLog>[],
      )
          .add(log);
    }

    // =============================================================
    // COMPLETED LOGS BY DATE
    // =============================================================

    completedLogsByDate =
    <DateTime, List<HabitLog>>{};

    for (final log in completedLogs) {
      final day =
      AppDateUtils.dateOnly(
        log.date,
      );

      completedLogsByDate
          .putIfAbsent(
        day,
            () => <HabitLog>[],
      )
          .add(log);
    }

    // =============================================================
    // DEBUG
    // =============================================================

    debugPrint(
      '========== STATISTICS CONTEXT ==========',
    );

    debugPrint(
      'Selected Date    : $selectedDate',
    );

    debugPrint(
      'Total Habits     : ${habits.length}',
    );

    debugPrint(
      'Active Habits    : ${activeHabits.length}',
    );

    debugPrint(
      'Total Logs       : ${logs.length}',
    );

    debugPrint(
      'Completed Logs   : ${completedLogs.length}',
    );

    debugPrint(
      '=========================================',
    );
  }

  // ===============================================================
  // SOURCE DATA
  // ===============================================================

  /// All habits, including archived habits.
  final List<Habit> habits;

  /// All habit logs.
  final List<HabitLog> logs;

  // ===============================================================
  // DERIVED DATA
  // ===============================================================

  /// Active, non-archived habits.
  late final List<Habit> activeHabits;

  /// Number of active habits.
  late final int activeHabitCount;

  /// Completed logs only.
  late final List<HabitLog> completedLogs;

  /// All logs grouped by date.
  late final Map<DateTime, List<HabitLog>>
  logsByDate;

  /// Completed logs grouped by date.
  late final Map<DateTime, List<HabitLog>>
  completedLogsByDate;

  /// Logs grouped by habit.
  late final Map<String, List<HabitLog>>
  logsByHabit;

  /// Fast habit lookup.
  late final Map<String, Habit>
  habitLookup;

  /// Date currently selected by the statistics UI.
  late DateTime selectedDate;

  // ===============================================================
  // EXPECTED HABITS
  // ===============================================================

  /// Returns the number of active habits that are scheduled
  /// to run on [date].
  ///
  /// Supported frequencies:
  ///
  /// daily
  /// weekly
  /// monthly
  /// custom
  ///
  /// A habit is only counted when:
  ///
  /// 1. It is not archived.
  /// 2. [date] is on/after its startDate.
  /// 3. [date] is on/before its endDate, if one exists.
  /// 4. Its frequency matches [date].
  int expectedHabitsForDate(
      DateTime date,
      ) {
    final normalizedDate =
    AppDateUtils.dateOnly(
      date,
    );

    var expected = 0;

    for (final habit in activeHabits) {
      if (!_isWithinHabitRange(
        habit,
        normalizedDate,
      )) {
        continue;
      }

      if (!_isHabitScheduledForDate(
        habit,
        normalizedDate,
      )) {
        continue;
      }

      expected++;
    }

    return expected;
  }

  // ===============================================================
  // HABIT RANGE
  // ===============================================================

  bool _isWithinHabitRange(
      Habit habit,
      DateTime date,
      ) {
    final startDate =
    AppDateUtils.dateOnly(
      habit.startDate,
    );

    if (date.isBefore(startDate)) {
      return false;
    }

    final endDate = habit.endDate;

    if (endDate != null) {
      final normalizedEndDate =
      AppDateUtils.dateOnly(
        endDate,
      );

      if (date.isAfter(
        normalizedEndDate,
      )) {
        return false;
      }
    }

    return true;
  }

  // ===============================================================
  // FREQUENCY
  // ===============================================================

  bool _isHabitScheduledForDate(
      Habit habit,
      DateTime date,
      ) {
    switch (habit.frequency) {
    // -----------------------------------------------------------
    // DAILY
    // -----------------------------------------------------------

      case HabitFrequency.daily:
        return true;

    // -----------------------------------------------------------
    // WEEKLY
    // -----------------------------------------------------------
    //
    // weeklyDays contains Dart weekday values:
    //
    // 1 = Monday
    // 2 = Tuesday
    // ...
    // 7 = Sunday
    //

      case HabitFrequency.weekly:
        return _matchesWeeklySchedule(
          habit,
          date,
        );

    // -----------------------------------------------------------
    // MONTHLY
    // -----------------------------------------------------------

      case HabitFrequency.monthly:
        return _matchesMonthlySchedule(
          habit,
          date,
        );

    // -----------------------------------------------------------
    // CUSTOM
    // -----------------------------------------------------------

      case HabitFrequency.custom:
        return _matchesCustomSchedule(
          habit,
          date,
        );
    }
  }

  // ===============================================================
  // WEEKLY SCHEDULE
  // ===============================================================

  bool _matchesWeeklySchedule(
      Habit habit,
      DateTime date,
      ) {
    final weeklyDays =
        habit.weeklyDays;

    if (weeklyDays.isEmpty) {
      return false;
    }

    return weeklyDays.contains(
      date.weekday,
    );
  }

  // ===============================================================
  // MONTHLY SCHEDULE
  // ===============================================================

  bool _matchesMonthlySchedule(
      Habit habit,
      DateTime date,
      ) {
    final monthlyDay =
        habit.monthlyDay;

    if (monthlyDay == null) {
      return false;
    }

    // -------------------------------------------------------------
    // Normal monthly day
    // -------------------------------------------------------------

    if (date.day == monthlyDay) {
      return true;
    }

    // -------------------------------------------------------------
    // If the requested day does not exist in a particular month,
    // use the final day of that month.
    //
    // Example:
    //
    // monthlyDay = 31
    //
    // February -> February 28/29
    // April    -> April 30
    // June     -> June 30
    // etc.
    // -------------------------------------------------------------

    final lastDayOfMonth =
        DateTime(
          date.year,
          date.month + 1,
          0,
        ).day;

    if (monthlyDay > lastDayOfMonth &&
        date.day == lastDayOfMonth) {
      return true;
    }

    return false;
  }

  // ===============================================================
  // CUSTOM SCHEDULE
  // ===============================================================

  bool _matchesCustomSchedule(
      Habit habit,
      DateTime date,
      ) {
    // -------------------------------------------------------------
    // IMPORTANT
    // -------------------------------------------------------------
    //
    // The current Habit model supplied to this class does not
    // expose a custom schedule field in the code provided earlier.
    //
    // Therefore there is no safe custom-frequency rule that can
    // be inferred here.
    //
    // Returning false prevents a custom habit from incorrectly
    // increasing the expected target every day.
    //
    // Once Habit has a custom schedule representation, this method
    // should be changed to evaluate it.
    //

    return false;
  }

  // ===============================================================
  // COMPLETION RATE
  // ===============================================================

  double calculateCompletionRate({
    required int completed,
    required int expected,
  }) {
    if (expected <= 0) {
      return 0.0;
    }

    return (
        completed / expected
    ).clamp(
      0.0,
      1.0,
    );
  }
}