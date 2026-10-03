import '../enums/habit_frequency.dart';
import '../models/habit.dart';
import '../models/habit_day_statistics.dart';
import '../models/habit_month_statistics.dart';
import '../models/habit_statistics.dart';
import '../models/habit_year_day_statistics.dart';
import '../models/xp_level.dart';

import '../calculators/xp_level_calculator.dart';
import '../enums/completion_status.dart';

import '../../data/entities/habit_log_entity.dart';

class HabitAnalyticsService {
  const HabitAnalyticsService();

  // =========================================================
  // OVERALL HABIT ANALYTICS
  // =========================================================

  static int totalXp(
      List<Habit> habits,
      ) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.xp,
    );
  }

  static int totalCompleted(
      List<Habit> habits,
      ) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.totalCompleted,
    );
  }

  static int currentStreak(
      List<Habit> habits,
      ) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.currentStreak,
    );
  }

  static int bestStreak(
      List<Habit> habits,
      ) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.bestStreak,
    );
  }

  static int activeHabits(
      List<Habit> habits,
      ) {
    return habits
        .where(
          (habit) => !habit.archived,
    )
        .length;
  }

  static int archivedHabits(
      List<Habit> habits,
      ) {
    return habits
        .where(
          (habit) => habit.archived,
    )
        .length;
  }

  static int completedToday(
      List<Habit> habits,
      ) {
    return habits
        .where(
          (habit) => habit.completedToday,
    )
        .length;
  }

  static int pendingToday(
      List<Habit> habits,
      ) {
    return habits
        .where(
          (habit) =>
      !habit.archived &&
          !habit.completedToday,
    )
        .length;
  }

  static XPLevel level(
      List<Habit> habits,
      ) {
    return XPLevelCalculator.calculate(
      totalXp(habits),
    );
  }

  // =========================================================
  // WEEKLY COMPLETION
  //
  // Returns 0.0 -> 100.0
  //
  // Existing dashboard/test contract:
  //
  // 1 completed out of 3 = 33.3333
  // 2 completed out of 4 = 50.0
  // =========================================================

  static double weeklyCompletion(
      List<Habit> habits,
      ) {
    if (habits.isEmpty) {
      return 0.0;
    }

    final completed =
    completedToday(habits);

    return (completed / habits.length) * 100.0;
  }

  // =========================================================
  // MONTHLY COMPLETION
  //
  // Currently follows the same dashboard metric contract
  // as weeklyCompletion().
  // =========================================================

  static double monthlyCompletion(
      List<Habit> habits,
      ) {
    return weeklyCompletion(habits);
  }

  // =========================================================
  // SUCCESS RATE
  //
  // Returns 0.0 -> 100.0
  //
  // Example:
  //
  // completedToday = 2
  // totalCompleted = 6
  //
  // 2 / 6 * 100 = 33.3333
  // =========================================================

  static double successRate(
      List<Habit> habits,
      ) {
    final completed =
    totalCompleted(habits);

    if (completed == 0) {
      return 0.0;
    }

    return (completedToday(habits) /
        completed) *
        100.0;
  }

  // =========================================================
  // INDIVIDUAL HABIT STATISTICS
  // =========================================================

  HabitStatistics buildStatistics(
      Habit habit,
      List<HabitLogEntity> logs, {
        DateTime? selectedDate,
      }) {
    final periodDate =
        selectedDate ?? DateTime.now();

    final tracking =
    trackingDays(habit);

    final completed =
        _completedLogs(logs).length;

    final missed =
    tracking > completed
        ? tracking - completed
        : 0;

    return HabitStatistics(
      currentStreak:
      habit.currentStreak,

      bestStreak:
      habit.bestStreak,

      totalCompleted:
      completed,

      totalMissed:
      missed,

      totalTrackedDays:
      tracking,

      activeDays:
      activeDays(logs),

      totalXP:
      habit.xp,

      completionRate:
      completionRate(
        habit,
        logs,
      ),

      successRate:
      habitSuccessRate(
        habit,
        logs,
      ),

      averagePerWeek:
      averagePerWeek(
        habit,
        logs,
      ),

      longestGap:
      longestGap(logs),

      weeklyProgress:
      weeklyProgressForDate(
        habit,
        logs,
        periodDate,
      ),

      monthlyProgress:
      monthlyProgressForDate(
        habit,
        logs,
        periodDate,
      ),

      yearlyProgress:
      yearlyProgressForYear(
        habit,
        logs,
        periodDate.year,
      ),
    );
  }

  // =========================================================
  // TRACKING DAYS
  //
  // Only scheduled days count.
  // =========================================================

  int trackingDays(
      Habit habit,
      ) {
    final today =
    _dateOnly(DateTime.now());

    final start =
    _dateOnly(habit.startDate);

    DateTime end;

    if (habit.endDate == null) {
      end = today;
    } else {
      end = _dateOnly(
        habit.endDate!,
      );

      if (end.isAfter(today)) {
        end = today;
      }
    }

    if (end.isBefore(start)) {
      return 0;
    }

    var count = 0;
    var current = start;

    while (!current.isAfter(end)) {
      if (isScheduledForDate(
        habit,
        current,
      )) {
        count++;
      }

      current = current.add(
        const Duration(days: 1),
      );
    }

    return count;
  }

  // =========================================================
  // SCHEDULE
  // =========================================================

  bool isScheduledForDate(
      Habit habit,
      DateTime date,
      ) {
    final day =
    _dateOnly(date);

    final start =
    _dateOnly(habit.startDate);

    // ---------------------------------------------------------
    // START DATE
    // ---------------------------------------------------------

    if (day.isBefore(start)) {
      return false;
    }

    // ---------------------------------------------------------
    // END DATE
    // ---------------------------------------------------------

    if (habit.endDate != null) {
      final end =
      _dateOnly(habit.endDate!);

      if (day.isAfter(end)) {
        return false;
      }
    }

    // ---------------------------------------------------------
    // FREQUENCY
    // ---------------------------------------------------------

    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;

      case HabitFrequency.weekly:
        if (habit.weeklyDays.isNotEmpty) {
          return habit.weeklyDays
              .contains(day.weekday);
        }

        return day.weekday ==
            start.weekday;

      case HabitFrequency.monthly:
        final monthlyDay =
            habit.monthlyDay;

        if (monthlyDay < 1 ||
            monthlyDay > 31) {
          return false;
        }

        return day.day ==
            monthlyDay;

      case HabitFrequency.custom:
        if (habit.weeklyDays.isNotEmpty) {
          return habit.weeklyDays
              .contains(day.weekday);
        }

        return true;
    }
  }

  // =========================================================
  // COMPLETION RATE
  //
  // Returns 0.0 -> 1.0
  // =========================================================

  double completionRate(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking =
    trackingDays(habit);

    if (tracking == 0) {
      return 0.0;
    }

    final completed =
        _completedLogs(logs).length;

    return (completed / tracking)
        .clamp(0.0, 1.0);
  }

  // =========================================================
  // SUCCESS RATE
  //
  // Returns 0.0 -> 100.0
  // =========================================================

  double habitSuccessRate(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final rate =
    completionRate(
      habit,
      logs,
    );

    return rate * 100.0;
  }

  // =========================================================
  // AVERAGE PER WEEK
  // =========================================================

  double averagePerWeek(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking =
    trackingDays(habit);

    if (tracking == 0) {
      return 0.0;
    }

    final completed =
        _completedLogs(logs).length;

    final weeks =
        tracking / 7.0;

    if (weeks <= 1) {
      return completed.toDouble();
    }

    return completed / weeks;
  }

  // =========================================================
  // ACTIVE DAYS
  // =========================================================

  int activeDays(
      List<HabitLogEntity> logs,
      ) {
    final uniqueDays =
    _completedLogs(logs)
        .map(
          (log) =>
          _dateOnly(log.date),
    )
        .toSet();

    return uniqueDays.length;
  }

  // =========================================================
  // LONGEST GAP
  // =========================================================

  int longestGap(
      List<HabitLogEntity> logs,
      ) {
    final completedLogs =
    _completedLogs(logs);

    if (completedLogs.length < 2) {
      return 0;
    }

    final dates =
    completedLogs
        .map(
          (log) =>
          _dateOnly(log.date),
    )
        .toSet()
        .toList()
      ..sort();

    var longest = 0;

    for (
    var i = 1;
    i < dates.length;
    i++
    ) {
      final gap =
          dates[i]
              .difference(
            dates[i - 1],
          )
              .inDays -
              1;

      if (gap > longest) {
        longest = gap;
      }
    }

    return longest;
  }

  // =========================================================
  // WEEKLY PROGRESS
  // =========================================================

  List<HabitDayStatistics> weeklyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    return weeklyProgressForDate(
      habit,
      logs,
      DateTime.now(),
    );
  }

  // =========================================================
  // MONTHLY PROGRESS
  // =========================================================

  List<HabitMonthStatistics> monthlyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      DateTime month,
      ) {
    return monthlyProgressForDate(
      habit,
      logs,
      month,
    );
  }

  // =========================================================
  // YEARLY PROGRESS
  // =========================================================

  List<HabitYearDayStatistics> yearlyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      int year,
      ) {
    return yearlyProgressForYear(
      habit,
      logs,
      year,
    );
  }

  // =========================================================
  // COMPLETED LOGS
  // =========================================================

  List<HabitLogEntity> _completedLogs(
      List<HabitLogEntity> logs,
      ) {
    return logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .toList();
  }

  // =========================================================
  // COMPLETED DATE SET
  // =========================================================

  Set<DateTime> _completedDateSet(
      List<HabitLogEntity> logs,
      ) {
    return _completedLogs(logs)
        .map(
          (log) =>
          _dateOnly(log.date),
    )
        .toSet();
  }

  // =========================================================
  // DATE ONLY
  // =========================================================

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // =========================================================
  // WEEKLY PROGRESS FOR SELECTED DATE
  // =========================================================

  List<HabitDayStatistics>
  weeklyProgressForDate(
      Habit habit,
      List<HabitLogEntity> logs,
      DateTime date,
      ) {
    final selected =
    _dateOnly(date);

    final monday =
    selected.subtract(
      Duration(
        days:
        selected.weekday -
            DateTime.monday,
      ),
    );

    final completedDates =
    _completedDateSet(logs);

    return List.generate(
      7,
          (index) {
        final day =
        monday.add(
          Duration(days: index),
        );

        final scheduled =
        isScheduledForDate(
          habit,
          day,
        );

        final completed =
            scheduled &&
                completedDates.contains(
                  day,
                );

        return HabitDayStatistics(
          date: day,
          completed: completed,
          isWithinHabitRange:
          scheduled,
        );
      },
    );
  }

  // =========================================================
  // MONTHLY PROGRESS FOR SELECTED MONTH
  // =========================================================

  List<HabitMonthStatistics>
  monthlyProgressForDate(
      Habit habit,
      List<HabitLogEntity> logs,
      DateTime date,
      ) {
    final firstDay =
    DateTime(
      date.year,
      date.month,
      1,
    );

    final lastDay =
    DateTime(
      date.year,
      date.month + 1,
      0,
    );

    final completedDates =
    _completedDateSet(logs);

    return List.generate(
      lastDay.day,
          (index) {
        final day =
        firstDay.add(
          Duration(days: index),
        );

        final scheduled =
        isScheduledForDate(
          habit,
          day,
        );

        final completed =
            scheduled &&
                completedDates.contains(
                  day,
                );

        return HabitMonthStatistics(
          date: day,
          completed: completed,
          isWithinHabitRange:
          scheduled,
        );
      },
    );
  }

  // =========================================================
  // YEARLY PROGRESS FOR SELECTED YEAR
  // =========================================================

  List<HabitYearDayStatistics>
  yearlyProgressForYear(
      Habit habit,
      List<HabitLogEntity> logs,
      int year,
      ) {
    final firstDay =
    DateTime(year, 1, 1);

    final lastDay =
    DateTime(year, 12, 31);

    final totalDays =
        lastDay
            .difference(firstDay)
            .inDays +
            1;

    final completedDates =
    _completedDateSet(logs);

    return List.generate(
      totalDays,
          (index) {
        final day =
        firstDay.add(
          Duration(days: index),
        );

        final scheduled =
        isScheduledForDate(
          habit,
          day,
        );

        final completed =
            scheduled &&
                completedDates.contains(
                  day,
                );

        return HabitYearDayStatistics(
          date: day,
          completed: completed,
          isWithinHabitRange:
          scheduled,
        );
      },
    );
  }
}