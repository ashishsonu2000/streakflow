import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/calendar/domain/models/calendar_day_view_model.dart';
import 'package:streak_calculator_flutter/features/calendar/domain/services/day_summary_builder.dart';
import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/mood_type.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_category.dart';

void main() {
  const builder = DaySummaryBuilder();

  group('DaySummaryBuilder', () {
    // ===============================================================
    // BASIC CALENDAR
    // ===============================================================

    test('builds exactly 42 calendar days', () {
      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: const [],
      );

      expect(result, hasLength(42));
    });

    test('calendar starts on Monday', () {
      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: const [],
      );

      expect(result.first.date.weekday, DateTime.monday);
    });

    test('calendar dates are consecutive', () {
      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: const [],
      );

      for (var i = 1; i < result.length; i++) {
        expect(
          result[i].date.difference(result[i - 1].date).inDays,
          1,
        );
      }
    });

    // ===============================================================
    // CURRENT MONTH
    // ===============================================================

    test('marks current month days correctly', () {
      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: const [],
      );

      final currentMonthDays = result
          .where((day) => day.isCurrentMonth)
          .toList();

      expect(
        currentMonthDays,
        isNotEmpty,
      );

      expect(
        currentMonthDays.every(
              (day) =>
          day.date.year == 2026 &&
              day.date.month == 8,
        ),
        isTrue,
      );
    });

    // ===============================================================
    // SELECTED DATE
    // ===============================================================

    test('marks selected date correctly', () {
      final selectedDate =
      DateTime(2026, 8, 15);

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: selectedDate,
        habits: const [],
        logs: const [],
      );

      final selectedDays =
      result.where(
            (day) => day.isSelected,
      );

      expect(
        selectedDays.length,
        1,
      );

      expect(
        selectedDays.first.date,
        DateTime(2026, 8, 15),
      );
    });

    test('does not mark another date as selected', () {
      final selectedDate =
      DateTime(2026, 8, 15);

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: selectedDate,
        habits: const [],
        logs: const [],
      );

      final unselectedDays = result.where(
            (day) =>
        !day.isSelected &&
            day.date.day != 15,
      );

      expect(
        unselectedDays.length,
        greaterThan(0),
      );
    });

    // ===============================================================
    // TODAY
    // ===============================================================

    test('marks today correctly when focused month is current month', () {
      final today = _dateOnly(DateTime.now());

      final result = builder.build(
        focusedMonth: DateTime(
          today.year,
          today.month,
        ),
        selectedDate: today,
        habits: const [],
        logs: const [],
      );

      final todayDays =
      result.where(
            (day) => day.isToday,
      );

      expect(
        todayDays.length,
        1,
      );

      expect(
        todayDays.first.date,
        today,
      );
    });

    // ===============================================================
    // EMPTY STATE
    // ===============================================================

    test('empty habits produce zero totals', () {
      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: const [],
      );

      for (final day in result) {
        expect(day.completedHabits, 0);
        expect(day.totalHabits, 0);
        expect(day.intensity, 0);
        expect(day.totalXP, 0);
        expect(day.totalDuration, 0);
        expect(day.firstCompletion, isNull);
        expect(day.lastCompletion, isNull);
        expect(day.dominantMood, isNull);
        expect(day.habits, isEmpty);
        expect(day.hasActivity, isFalse);
        expect(day.completionRate, 0);
      }
    });

    // ===============================================================
    // ACTIVE HABIT
    // ===============================================================

    test('habit is active on and after its start date', () {
      final habit = _habit(
        id: 'habit-1',
        startDate: DateTime(2026, 8, 10),
      );

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: [habit],
        logs: const [],
      );

      final beforeStart =
      _findDay(result, 2026, 8, 9);

      final startDay =
      _findDay(result, 2026, 8, 10);

      final afterStart =
      _findDay(result, 2026, 8, 11);

      expect(
        beforeStart.totalHabits,
        0,
      );

      expect(
        startDay.totalHabits,
        1,
      );

      expect(
        afterStart.totalHabits,
        1,
      );
    });

    // ===============================================================
    // END DATE
    // ===============================================================

    test('habit remains active through its end date', () {
      final habit = _habit(
        id: 'habit-1',
        startDate: DateTime(2026, 8, 10),
        endDate: DateTime(2026, 8, 15),
      );

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: [habit],
        logs: const [],
      );

      final beforeEnd =
      _findDay(result, 2026, 8, 14);

      final endDay =
      _findDay(result, 2026, 8, 15);

      final afterEnd =
      _findDay(result, 2026, 8, 16);

      expect(
        beforeEnd.totalHabits,
        1,
      );

      expect(
        endDay.totalHabits,
        1,
      );

      expect(
        afterEnd.totalHabits,
        0,
      );
    });

    // ===============================================================
    // COMPLETED HABIT
    // ===============================================================

    test('completed log increases completed habit count', () {
      final habit = _habit(
        id: 'habit-1',
        startDate: DateTime(2026, 8, 1),
      );

      final log = _completedLog(
        habitId: 'habit-1',
        date: DateTime(2026, 8, 15),
        xpEarned: 10,
        durationMinutes: 20,
      );

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: [habit],
        logs: [log],
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.completedHabits,
        1,
      );

      expect(
        day.totalHabits,
        1,
      );

      expect(
        day.hasActivity,
        isTrue,
      );

      expect(
        day.completionRate,
        1.0,
      );
    });

    // ===============================================================
    // XP
    // ===============================================================

    test('calculates total XP for the day', () {
      final habits = [
        _habit(
          id: 'habit-1',
          startDate: DateTime(2026, 8, 1),
        ),
        _habit(
          id: 'habit-2',
          startDate: DateTime(2026, 8, 1),
        ),
      ];

      final logs = [
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
          xpEarned: 10,
        ),
        _completedLog(
          habitId: 'habit-2',
          date: DateTime(2026, 8, 15),
          xpEarned: 25,
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.totalXP,
        35,
      );
    });

    // ===============================================================
    // DURATION
    // ===============================================================

    test('calculates total duration for the day', () {
      final habits = [
        _habit(
          id: 'habit-1',
          startDate: DateTime(2026, 8, 1),
        ),
        _habit(
          id: 'habit-2',
          startDate: DateTime(2026, 8, 1),
        ),
      ];

      final logs = [
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
          durationMinutes: 20,
        ),
        _completedLog(
          habitId: 'habit-2',
          date: DateTime(2026, 8, 15),
          durationMinutes: 35,
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.totalDuration,
        55,
      );
    });

    // ===============================================================
    // FIRST / LAST COMPLETION
    // ===============================================================

    test('calculates first and last completion times', () {
      final habits = [
        _habit(
          id: 'habit-1',
          startDate: DateTime(2026, 8, 1),
        ),
        _habit(
          id: 'habit-2',
          startDate: DateTime(2026, 8, 1),
        ),
      ];

      final first =
      DateTime(2026, 8, 15, 8, 30);

      final last =
      DateTime(2026, 8, 15, 20, 45);

      final logs = [
        _completedLog(
          habitId: 'habit-2',
          date: DateTime(2026, 8, 15),
          completedAt: last,
        ),
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
          completedAt: first,
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.firstCompletion,
        first,
      );

      expect(
        day.lastCompletion,
        last,
      );
    });

    // ===============================================================
    // MOOD
    // ===============================================================

    test('calculates dominant mood', () {
      final habits = [
        _habit(
          id: 'habit-1',
          startDate: DateTime(2026, 8, 1),
        ),
        _habit(
          id: 'habit-2',
          startDate: DateTime(2026, 8, 1),
        ),
        _habit(
          id: 'habit-3',
          startDate: DateTime(2026, 8, 1),
        ),
      ];

      final logs = [
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
          mood: MoodType.happy,
        ),
        _completedLog(
          habitId: 'habit-2',
          date: DateTime(2026, 8, 15),
          mood: MoodType.happy,
        ),
        _completedLog(
          habitId: 'habit-3',
          date: DateTime(2026, 8, 15),
          mood: MoodType.sad,
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.dominantMood,
        MoodType.happy,
      );
    });

    // ===============================================================
    // DAY HABITS
    // ===============================================================

    test('creates day habit view models for active habits', () {
      final habits = [
        _habit(
          id: 'habit-1',
          title: 'Reading',
          startDate: DateTime(2026, 8, 1),
        ),
        _habit(
          id: 'habit-2',
          title: 'Exercise',
          startDate: DateTime(2026, 8, 1),
        ),
      ];

      final logs = [
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
          xpEarned: 10,
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.habits,
        hasLength(2),
      );

      final reading =
      day.habits.firstWhere(
            (habit) => habit.id == 'habit-1',
      );

      final exercise =
      day.habits.firstWhere(
            (habit) => habit.id == 'habit-2',
      );

      expect(
        reading.title,
        'Reading',
      );

      expect(
        reading.completed,
        isTrue,
      );

      expect(
        reading.xpEarned,
        10,
      );

      expect(
        exercise.title,
        'Exercise',
      );

      expect(
        exercise.completed,
        isFalse,
      );
    });

    // ===============================================================
    // INACTIVE HABIT LOG
    // ===============================================================

    test('ignores logs for habits that are not active on that date', () {
      final habit = _habit(
        id: 'habit-1',
        startDate: DateTime(2026, 8, 20),
      );

      final log = _completedLog(
        habitId: 'habit-1',
        date: DateTime(2026, 8, 15),
        xpEarned: 50,
      );

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: [habit],
        logs: [log],
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.totalHabits,
        0,
      );

      expect(
        day.completedHabits,
        0,
      );

      expect(
        day.totalXP,
        0,
      );

      expect(
        day.habits,
        isEmpty,
      );
    });

    // ===============================================================
    // UNKNOWN HABIT LOG
    // ===============================================================

    test('ignores logs whose habit does not exist', () {
      final log = _completedLog(
        habitId: 'unknown-habit',
        date: DateTime(2026, 8, 15),
        xpEarned: 100,
      );

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: [log],
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.completedHabits,
        0,
      );

      expect(
        day.totalXP,
        0,
      );
    });

    // ===============================================================
    // DUPLICATE LOGS
    // ===============================================================

    test('duplicate logs for the same habit count as one completed habit',
            () {
          final habit = _habit(
            id: 'habit-1',
            startDate: DateTime(2026, 8, 1),
          );

          final logs = [
            _completedLog(
              habitId: 'habit-1',
              date: DateTime(2026, 8, 15),
              xpEarned: 10,
            ),
            _completedLog(
              habitId: 'habit-1',
              date: DateTime(2026, 8, 15),
              xpEarned: 20,
            ),
          ];

          final result = builder.build(
            focusedMonth: DateTime(2026, 8),
            selectedDate: DateTime(2026, 8, 15),
            habits: [habit],
            logs: logs,
          );

          final day =
          _findDay(result, 2026, 8, 15);

          expect(
            day.completedHabits,
            1,
          );

          // Current implementation sums all day logs.
          expect(
            day.totalXP,
            30,
          );
        });

    // ===============================================================
    // INTENSITY
    // ===============================================================

    test('intensity is zero when there are no habits', () {
      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: const [],
        logs: const [],
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.intensity,
        0,
      );
    });

    test('intensity is one below fifty percent', () {
      final habits = List.generate(
        4,
            (index) => _habit(
          id: 'habit-$index',
          startDate: DateTime(2026, 8, 1),
        ),
      );

      final logs = [
        _completedLog(
          habitId: 'habit-0',
          date: DateTime(2026, 8, 15),
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.completedHabits,
        1,
      );

      expect(
        day.totalHabits,
        4,
      );

      expect(
        day.intensity,
        1,
      );
    });

    test('intensity is two at fifty percent', () {
      final habits = List.generate(
        4,
            (index) => _habit(
          id: 'habit-$index',
          startDate: DateTime(2026, 8, 1),
        ),
      );

      final logs = [
        _completedLog(
          habitId: 'habit-0',
          date: DateTime(2026, 8, 15),
        ),
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.intensity,
        2,
      );
    });

    test('intensity is three at seventy five percent', () {
      final habits = List.generate(
        4,
            (index) => _habit(
          id: 'habit-$index',
          startDate: DateTime(2026, 8, 1),
        ),
      );

      final logs = [
        _completedLog(
          habitId: 'habit-0',
          date: DateTime(2026, 8, 15),
        ),
        _completedLog(
          habitId: 'habit-1',
          date: DateTime(2026, 8, 15),
        ),
        _completedLog(
          habitId: 'habit-2',
          date: DateTime(2026, 8, 15),
        ),
      ];

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.intensity,
        3,
      );
    });

    test('intensity is four when all habits are completed', () {
      final habits = List.generate(
        4,
            (index) => _habit(
          id: 'habit-$index',
          startDate: DateTime(2026, 8, 1),
        ),
      );

      final logs = List.generate(
        4,
            (index) => _completedLog(
          habitId: 'habit-$index',
          date: DateTime(2026, 8, 15),
        ),
      );

      final result = builder.build(
        focusedMonth: DateTime(2026, 8),
        selectedDate: DateTime(2026, 8, 15),
        habits: habits,
        logs: logs,
      );

      final day =
      _findDay(result, 2026, 8, 15);

      expect(
        day.intensity,
        4,
      );

      expect(
        day.completionRate,
        1.0,
      );
    });
  });
}

// =====================================================================
// HELPERS
// =====================================================================

Habit _habit({
  required String id,
  String title = 'Test Habit',
  required DateTime startDate,
  DateTime? endDate,
}) {
  final now = DateTime.now();

  return Habit(
    id: id,
    title: title,
    category: HabitCategory.personal,
    frequency: HabitFrequency.daily,
    createdAt: now,
    updatedAt: now,
    startDate: startDate,
    endDate: endDate,
  );
}

HabitLogEntity _completedLog({
  required String habitId,
  required DateTime date,
  int xpEarned = 0,
  int durationMinutes = 0,
  DateTime? completedAt,
  MoodType? mood,
}) {
  final log = HabitLogEntity()
    ..habitId = habitId
    ..date = date
    ..status = CompletionStatus.completed
    ..xpEarned = xpEarned
    ..durationMinutes = durationMinutes
    ..completedAt = completedAt
    ..mood = mood;

  return log;
}

CalendarDayViewModel _findDay(
    List<CalendarDayViewModel> days,
    int year,
    int month,
    int day,
    ) {
  return days.firstWhere(
        (item) =>
    item.date.year == year &&
        item.date.month == month &&
        item.date.day == day,
  );
}

DateTime _dateOnly(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
  );
}