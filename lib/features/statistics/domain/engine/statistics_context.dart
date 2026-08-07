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
  }) {
    //------------------------------------------
    // Active Habits
    //------------------------------------------

    activeHabits =
        habits.where((habit) => !habit.archived).toList(growable: false);

    activeHabitCount = activeHabits.length;

    //------------------------------------------
    // Completed Logs
    //------------------------------------------

    completedLogs = logs
        .where(
          (log) => log.status == CompletionStatus.completed,
        )
        .toList(growable: false);
    debugPrint('========== Statistics Context ==========');
    debugPrint('Total Habits      : ${habits.length}');
    debugPrint('Active Habits     : ${activeHabits.length}');
    debugPrint('Total Logs        : ${logs.length}');
    debugPrint('Completed Logs    : ${completedLogs.length}');

    for (final habit in activeHabits) {
      debugPrint(
        'Habit: ${habit.title} | archived=${habit.archived}',
      );
    }
    //------------------------------------------
    // Habit Lookup
    //------------------------------------------

    habitLookup = {
      for (final habit in habits) habit.id: habit,
    };

    //------------------------------------------
    // Logs By Habit
    //------------------------------------------

    logsByHabit = <String, List<HabitLog>>{};

    for (final log in logs) {
      logsByHabit
          .putIfAbsent(
            log.habitId,
            () => <HabitLog>[],
          )
          .add(log);
    }

    //------------------------------------------
    // Logs By Date
    //------------------------------------------

    logsByDate = <DateTime, List<HabitLog>>{};

    for (final log in logs) {
      final day = AppDateUtils.dateOnly(log.date);

      logsByDate
          .putIfAbsent(
            day,
            () => <HabitLog>[],
          )
          .add(log);
    }

    //------------------------------------------
    // Completed Logs By Date
    //------------------------------------------

    completedLogsByDate = <DateTime, List<HabitLog>>{};

    for (final log in completedLogs) {
      final day = AppDateUtils.dateOnly(log.date);

      completedLogsByDate
          .putIfAbsent(
            day,
            () => <HabitLog>[],
          )
          .add(log);
    }
  }

  /// All habits (including archived)
  final List<Habit> habits;

  /// All habit logs
  final List<HabitLog> logs;

  /// Active (non-archived) habits
  late final List<Habit> activeHabits;

  /// Number of active habits
  late final int activeHabitCount;

  /// Completed logs only
  late final List<HabitLog> completedLogs;

  /// Logs grouped by date
  late final Map<DateTime, List<HabitLog>> logsByDate;

  /// Completed logs grouped by date
  late final Map<DateTime, List<HabitLog>> completedLogsByDate;

  /// Logs grouped by habit
  late final Map<String, List<HabitLog>> logsByHabit;

  /// Fast habit lookup by id
  late final Map<String, Habit> habitLookup;

  /// Returns the number of habits expected to be completed on [date].
  ///
  /// Currently every active habit is treated as a daily habit.
  /// In future this method will respect HabitFrequency
  /// (daily, weekly, monthly, custom, etc.).
  int expectedHabitsForDate(DateTime date) {
    return activeHabits.where((habit) {
      debugPrint(
        'Expected habits on $date = $activeHabitCount',
      );
      switch (habit.frequency) {
        case HabitFrequency.daily:
          return true;

        case HabitFrequency.weekly:
          // TODO: Match selected weekday(s)
          return true;

        case HabitFrequency.monthly:
          // TODO: Match selected day of month
          return true;

        default:
          return true;
      }
    }).length;
  }

  double calculateCompletionRate({
    required int completed,
    required int expected,
  }) {
    if (expected <= 0) {
      return 0.0;
    }

    return (completed / expected).clamp(0.0, 1.0);
  }
}
