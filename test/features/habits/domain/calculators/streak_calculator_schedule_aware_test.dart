import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/domain/calculators/streak_calculator.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';

// =====================================================================
// Regression coverage for the persisted (dashboard) streak calculator
// becoming recurrence-aware. Before this fix, `StreakCalculator.calculate`
// always walked *consecutive calendar days*, so a weekly/monthly habit's
// currentStreak/longestStreak reset every time a non-scheduled day fell
// in between two real completions - even though the Statistics screen
// (which was already recurrence-aware) showed the correct streak for
// the very same habit.
// =====================================================================

void main() {
  group('StreakCalculator with habit (recurrence-aware)', () {
    test(
      'weekly habit is not broken by non-scheduled days in between',
      () {
        final today = _dateOnly(DateTime.now());

        final habit = _habit(
          frequency: HabitFrequency.weekly,
          weeklyDays: [today.weekday],
          startDate: today.subtract(const Duration(days: 30)),
        );

        // Completed on the same weekday for the last 3 occurrences,
        // i.e. today, 7 days ago and 14 days ago. Every day in
        // between is NOT scheduled and must not break the streak.
        final logs = [
          _completedLog(today),
          _completedLog(today.subtract(const Duration(days: 7))),
          _completedLog(today.subtract(const Duration(days: 14))),
        ];

        final result = StreakCalculator.calculate(
          logs,
          habit: habit,
        );

        expect(result.currentStreak, 3);
        expect(result.longestStreak, 3);
      },
    );

    test(
      'weekly habit streak breaks when a scheduled occurrence is missed',
      () {
        final today = _dateOnly(DateTime.now());

        final habit = _habit(
          frequency: HabitFrequency.weekly,
          weeklyDays: [today.weekday],
          startDate: today.subtract(const Duration(days: 30)),
        );

        final logs = [
          _completedLog(today),
          // 7 days ago (previous scheduled occurrence) is missing.
          _completedLog(today.subtract(const Duration(days: 14))),
        ];

        final result = StreakCalculator.calculate(
          logs,
          habit: habit,
        );

        expect(result.currentStreak, 1);
        expect(result.longestStreak, 1);
      },
    );

    test(
      'monthly habit longest streak spans months without being '
      'penalized for the days in between',
      () {
        // Deliberately historical (not anchored to "today") since
        // longestStreak does not depend on the current date, unlike
        // currentStreak.
        final habit = _habit(
          frequency: HabitFrequency.monthly,
          monthlyDay: 15,
          startDate: DateTime(2024, 1, 1),
        );

        final logs = [
          _completedLog(DateTime(2024, 1, 15)),
          _completedLog(DateTime(2024, 2, 15)),
          _completedLog(DateTime(2024, 3, 15)),
        ];

        final result = StreakCalculator.calculate(
          logs,
          habit: habit,
        );

        expect(result.longestStreak, 3);
      },
    );

    test(
      'archived habit keeps its historical streak',
      () {
        final today = _dateOnly(DateTime.now());

        final habit = _habit(
          frequency: HabitFrequency.daily,
          startDate: today.subtract(const Duration(days: 10)),
          archived: true,
        );

        final logs = [
          _completedLog(today.subtract(const Duration(days: 2))),
          _completedLog(today.subtract(const Duration(days: 1))),
        ];

        final result = StreakCalculator.calculate(
          logs,
          habit: habit,
        );

        expect(result.longestStreak, 2);
      },
    );
  });
}

// =====================================================================
// TEST HELPERS
// =====================================================================

HabitLogEntity _completedLog(DateTime date) {
  return HabitLogEntity()
    ..date = date
    ..habitId = 'test-habit'
    ..status = CompletionStatus.completed;
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

Habit _habit({
  required HabitFrequency frequency,
  required DateTime startDate,
  List<int> weeklyDays = const [],
  int monthlyDay = 1,
  bool archived = false,
}) {
  final now = DateTime.now();

  return Habit(
    id: 'test-habit',
    title: 'Test Habit',
    frequency: frequency,
    createdAt: now,
    updatedAt: now,
    startDate: startDate,
    weeklyDays: weeklyDays,
    monthlyDay: monthlyDay,
    archived: archived,
  );
}
