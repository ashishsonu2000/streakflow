import '../models/habit_day_statistics.dart';
import '../calculators/xp_level_calculator.dart';
import '../enums/completion_status.dart';
import '../models/habit.dart';
import '../models/habit_month_statistics.dart';
import '../models/habit_statistics.dart';
import '../models/habit_year_day_statistics.dart';
import '../models/xp_level.dart';

import '../../data/entities/habit_log_entity.dart';

class HabitAnalyticsService {
  const HabitAnalyticsService();

  // =========================================================
  // Overall Habit Analytics
  // =========================================================

  static int totalXp(List<Habit> habits) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.xp,
    );
  }

  static int totalCompleted(List<Habit> habits) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.totalCompleted,
    );
  }

  static int currentStreak(List<Habit> habits) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.currentStreak,
    );
  }

  static int bestStreak(List<Habit> habits) {
    return habits.fold(
      0,
          (sum, habit) => sum + habit.bestStreak,
    );
  }

  static int activeHabits(List<Habit> habits) {
    return habits
        .where((habit) => !habit.archived)
        .length;
  }

  static int archivedHabits(List<Habit> habits) {
    return habits
        .where((habit) => habit.archived)
        .length;
  }

  static int completedToday(List<Habit> habits) {
    return habits
        .where((habit) => habit.completedToday)
        .length;
  }

  static int pendingToday(List<Habit> habits) {
    return habits
        .where(
          (habit) =>
      !habit.archived &&
          !habit.completedToday,
    )
        .length;
  }

  static XPLevel level(List<Habit> habits) {
    return XPLevelCalculator.calculate(
      totalXp(habits),
    );
  }

  static double weeklyCompletion(
      List<Habit> habits,
      ) {
    if (habits.isEmpty) {
      return 0;
    }

    return completedToday(habits) /
        habits.length *
        100;
  }

  static double monthlyCompletion(
      List<Habit> habits,
      ) {
    // Temporary implementation.
    return weeklyCompletion(habits);
  }

  static double successRate(
      List<Habit> habits,
      ) {
    final completed = totalCompleted(habits);

    if (completed == 0) {
      return 0;
    }

    return completedToday(habits) /
        completed *
        100;
  }

  // =========================================================
  // Individual Habit Statistics
  // =========================================================

  HabitStatistics buildStatistics(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking = trackingDays(habit);

    final completed = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .length;

    final missed =
    tracking > completed
        ? tracking - completed
        : 0;

    return HabitStatistics(
      currentStreak: habit.currentStreak,
      bestStreak: habit.bestStreak,
      totalCompleted: completed,
      totalMissed: missed,
      totalTrackedDays: tracking,
      activeDays: activeDays(logs),
      totalXP: habit.xp,
      completionRate: completionRate(
        habit,
        logs,
      ),
      successRate: habitSuccessRate(
        habit,
        logs,
      ),
      averagePerWeek: averagePerWeek(
        habit,
        logs,
      ),
      longestGap: longestGap(logs),
      weeklyProgress: weeklyProgress(
        habit,
        logs,
      ),
      monthlyProgress: monthlyProgress(
        habit,
        logs,
        DateTime.now(),
      ),
      yearlyProgress: yearlyProgress(
        habit,
        logs,
        DateTime.now().year,
      ),
    );
  }



  // =========================================================
  // Tracking Days
  // =========================================================

  int trackingDays(
      Habit habit,
      ) {
    final today = DateTime.now();

    final start = DateTime(
      habit.startDate.year,
      habit.startDate.month,
      habit.startDate.day,
    );

    final end = habit.endDate == null
        ? DateTime(
      today.year,
      today.month,
      today.day,
    )
        : DateTime(
      habit.endDate!.year,
      habit.endDate!.month,
      habit.endDate!.day,
    );

    final effectiveEnd =
    end.isAfter(today)
        ? DateTime(
      today.year,
      today.month,
      today.day,
    )
        : end;

    if (effectiveEnd.isBefore(start)) {
      return 0;
    }

    return effectiveEnd
        .difference(start)
        .inDays +
        1;
  }

  // =========================================================
  // Completion Rate
  // =========================================================

  double completionRate(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking = trackingDays(habit);

    if (tracking == 0) {
      return 0;
    }

    final completed = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .length;

    return completed / tracking * 100;
  }

  // =========================================================
  // Habit Success Rate
  // =========================================================

  double habitSuccessRate(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    return completionRate(
      habit,
      logs,
    );
  }

  // =========================================================
  // Average Per Week
  // =========================================================

  double averagePerWeek(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final tracking = trackingDays(habit);

    if (tracking == 0) {
      return 0;
    }

    final completed = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .length;

    final weeks = tracking / 7;

    if (weeks <= 1) {
      return completed.toDouble();
    }

    return completed / weeks;
  }

  // =========================================================
  // Active Days
  // =========================================================

  int activeDays(
      List<HabitLogEntity> logs,
      ) {
    final uniqueDays = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .map(
          (log) => DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      ),
    )
        .toSet();

    return uniqueDays.length;
  }

  // =========================================================
  // Longest Gap
  // =========================================================

  int longestGap(
      List<HabitLogEntity> logs,
      ) {
    final completedLogs = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .toList();

    if (completedLogs.length < 2) {
      return 0;
    }

    final dates = completedLogs
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

    var longest = 0;

    for (var i = 1; i < dates.length; i++) {
      final gap =
          dates[i]
              .difference(dates[i - 1])
              .inDays -
              1;

      if (gap > longest) {
        longest = gap;
      }
    }

    return longest;
  }


  List<HabitDayStatistics> weeklyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      ) {
    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final monday = todayOnly.subtract(
      Duration(
        days: todayOnly.weekday - 1,
      ),
    );

    final completedDates = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .map(
          (log) => DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      ),
    )
        .toSet();

    return List.generate(
      7,
          (index) {
        final date = monday.add(
          Duration(days: index),
        );

        final withinHabitRange =
            !date.isBefore(
              DateTime(
                habit.startDate.year,
                habit.startDate.month,
                habit.startDate.day,
              ),
            ) &&
                (habit.endDate == null ||
                    !date.isAfter(
                      DateTime(
                        habit.endDate!.year,
                        habit.endDate!.month,
                        habit.endDate!.day,
                      ),
                    ));

        return HabitDayStatistics(
          date: date,
          completed:
          withinHabitRange &&
              completedDates.contains(date),
        );
      },
    );
  }


  List<HabitMonthStatistics> monthlyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      DateTime month,
      ) {
    final firstDay = DateTime(
      month.year,
      month.month,
      1,
    );

    final lastDay = DateTime(
      month.year,
      month.month + 1,
      0,
    );

    final habitStart = DateTime(
      habit.startDate.year,
      habit.startDate.month,
      habit.startDate.day,
    );

    final habitEnd = habit.endDate == null
        ? null
        : DateTime(
      habit.endDate!.year,
      habit.endDate!.month,
      habit.endDate!.day,
    );

    final completedDates = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .map(
          (log) => DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      ),
    )
        .toSet();

    return List.generate(
      lastDay.day,
          (index) {
        final date = firstDay.add(
          Duration(days: index),
        );

        final withinHabitRange =
            !date.isBefore(habitStart) &&
                (habitEnd == null ||
                    !date.isAfter(habitEnd));

        return HabitMonthStatistics(
          date: date,
          completed:
          withinHabitRange &&
              completedDates.contains(date),
          isWithinHabitRange:
          withinHabitRange,
        );
      },
    );
  }

  List<HabitYearDayStatistics> yearlyProgress(
      Habit habit,
      List<HabitLogEntity> logs,
      int year,
      ) {
    final firstDay = DateTime(
      year,
      1,
      1,
    );

    final lastDay = DateTime(
      year + 1,
      1,
      0,
    );

    final habitStart = DateTime(
      habit.startDate.year,
      habit.startDate.month,
      habit.startDate.day,
    );

    final habitEnd = habit.endDate == null
        ? null
        : DateTime(
      habit.endDate!.year,
      habit.endDate!.month,
      habit.endDate!.day,
    );

    final completedDates = logs
        .where(
          (log) =>
      log.status ==
          CompletionStatus.completed,
    )
        .map(
          (log) => DateTime(
        log.date.year,
        log.date.month,
        log.date.day,
      ),
    )
        .toSet();

    final totalDays =
        lastDay.difference(firstDay).inDays;

    return List.generate(
      totalDays,
          (index) {
        final date = firstDay.add(
          Duration(days: index),
        );

        final withinHabitRange =
            !date.isBefore(habitStart) &&
                (habitEnd == null ||
                    !date.isAfter(habitEnd));

        return HabitYearDayStatistics(
          date: date,
          completed:
          withinHabitRange &&
              completedDates.contains(date),
          isWithinHabitRange:
          withinHabitRange,
        );
      },
    );
  }
}