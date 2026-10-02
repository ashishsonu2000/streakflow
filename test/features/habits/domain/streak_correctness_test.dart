import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/calculators/schedule_aware_streak_calculator.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/calculators/overview/streak_calculator.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/calculators/performance/performance_calculator.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/engine/statistics_context.dart';

/// Friday 2 October 2026.
final _today = DateTime(2026, 10, 2);

DateTime _day(int offset) =>
    DateTime(_today.year, _today.month, _today.day + offset);

Habit _habit({
  HabitFrequency frequency = HabitFrequency.daily,
  List<int> weeklyDays = const [],
  int monthlyDay = 1,
}) {
  final start = DateTime(2026, 6, 1);
  return Habit(
    id: 'h',
    title: 'Habit',
    frequency: frequency,
    weeklyDays: weeklyDays,
    monthlyDay: monthlyDay,
    createdAt: start,
    updatedAt: start,
    startDate: start,
  );
}

int _current(Habit habit, List<DateTime> days) =>
    const ScheduleAwareStreakCalculator()
        .calculate(habit, days, today: _today)
        .currentStreak;

HabitLog _log(DateTime date, {CompletionStatus status = CompletionStatus.completed}) =>
    HabitLog(
      id: '${date.toIso8601String()}-${status.name}',
      habitId: 'h',
      date: date,
      status: status,
      completedAt: date.add(const Duration(hours: 9)),
      durationMinutes: 0,
      notes: '',
      xpEarned: status == CompletionStatus.completed ? 5 : 0,
    );

void main() {
  group('daily habit streak', () {
    // Completed the 3 days before today.
    final lastThree = [_day(-3), _day(-2), _day(-1)];

    test('today not done yet: the streak is kept (today is still open)', () {
      expect(_current(_habit(), lastThree), 3);
    });

    test('today done: today counts', () {
      expect(_current(_habit(), [...lastThree, _today]), 4);
    });

    test('undoing today returns to the previous streak, not 0', () {
      final withToday = _current(_habit(), [...lastThree, _today]);
      final undone = _current(_habit(), lastThree);

      expect(withToday, 4);
      expect(undone, 3);
    });

    test('a missed day breaks the streak', () {
      // Yesterday missed.
      expect(_current(_habit(), [_day(-3), _day(-2)]), 0);
      expect(_current(_habit(), [_day(-3), _day(-2), _today]), 1);
    });

    test('best streak keeps the longest run', () {
      final result = const ScheduleAwareStreakCalculator().calculate(
        _habit(),
        [_day(-10), _day(-9), _day(-8), _day(-7), _day(-1)],
        today: _today,
      );

      expect(result.currentStreak, 1);
      expect(result.longestStreak, 4);
    });

    test('duplicate days count once', () {
      expect(_current(_habit(), [_day(-1), _day(-1), _day(-2)]), 2);
    });
  });

  group('weekly habit streak (Mon, Wed, Fri; today is Friday)', () {
    final mwf = _habit(
      frequency: HabitFrequency.weekly,
      weeklyDays: const [1, 3, 5],
    );

    // Mon 28 Sep, Wed 30 Sep.
    final earlierThisWeek = [_day(-4), _day(-2)];

    test('Friday not done yet: Mon + Wed streak kept', () {
      expect(_current(mwf, earlierThisWeek), 2);
    });

    test('Friday done: 3', () {
      expect(_current(mwf, [...earlierThisWeek, _today]), 3);
    });

    test('non-scheduled days in between do not break it', () {
      // Fri 25 Sep, Mon, Wed - Tue/Thu/weekend are not scheduled.
      expect(_current(mwf, [_day(-7), ...earlierThisWeek]), 3);
    });

    test('a missed scheduled day breaks it', () {
      // Wednesday missed.
      expect(_current(mwf, [_day(-4)]), 0);
    });

    test('on an off day the streak runs to the last scheduled day', () {
      final tuesdayThursday = _habit(
        frequency: HabitFrequency.weekly,
        weeklyDays: const [2, 4],
      );

      // Today (Fri) is not scheduled; Tue 29 + Thu 1 done.
      expect(_current(tuesdayThursday, [_day(-3), _day(-1)]), 2);
    });
  });

  test('monthly habit: streak across months, today still open', () {
    final second = _habit(frequency: HabitFrequency.monthly, monthlyDay: 2);

    // 2 Aug, 2 Sep done; today (2 Oct) not yet.
    expect(
      _current(second, [DateTime(2026, 8, 2), DateTime(2026, 9, 2)]),
      2,
    );
  });

  group('overall (calendar) streak on the Statistics screen', () {
    StreakCalculator calc() => const StreakCalculator();

    test('an old run is not a current streak', () {
      final result = calc().calculate(
        [_log(DateTime(2026, 9, 1)), _log(DateTime(2026, 9, 2))],
        today: _today,
      );

      expect(result.currentStreak, 0);
      expect(result.longestStreak, 2);
    });

    test('today still open: the run through yesterday counts', () {
      final result = calc().calculate(
        [_log(_day(-2)), _log(_day(-1))],
        today: _today,
      );

      expect(result.currentStreak, 2);
    });

    test('across a month boundary', () {
      final result = calc().calculate(
        [_log(DateTime(2026, 9, 30)), _log(DateTime(2026, 10, 1)), _log(_today)],
        today: _today,
      );

      expect(result.currentStreak, 3);
    });
  });

  test('performance: skipped and missed logs are not completions', () {
    final habit = _habit();
    final context = StatisticsContext(
      habits: [habit],
      logs: [
        _log(_day(-2)),
        _log(_day(-1), status: CompletionStatus.skipped),
        _log(_day(-3), status: CompletionStatus.missed),
      ],
      selectedDate: _today,
    );

    final performance = const PerformanceCalculator().calculate(context).single;

    expect(performance.totalCompleted, 1);
    expect(performance.totalXP, 5);
    // Yesterday was skipped, so there is no current streak.
    expect(performance.currentStreak, 0);
  });
}
