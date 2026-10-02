import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/calculators/trends/trend_calculator.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/engine/statistics_context.dart';

final _now = DateTime.now();
final _today = DateTime(_now.year, _now.month, _now.day);
final _yesterday = DateTime(_today.year, _today.month, _today.day - 1);

Habit _habit(String id, {List<int>? weekdays, bool archived = false}) {
  final start = DateTime(_today.year, _today.month, _today.day - 60);
  return Habit(
    id: id,
    title: id,
    frequency: weekdays == null ? HabitFrequency.daily : HabitFrequency.weekly,
    weeklyDays: weekdays ?? const [],
    archived: archived,
    createdAt: start,
    updatedAt: start,
    startDate: start,
  );
}

HabitLog _log(String habitId, DateTime day,
        {CompletionStatus status = CompletionStatus.completed}) =>
    HabitLog(
      id: '$habitId-${day.toIso8601String()}-${status.name}',
      habitId: habitId,
      date: day,
      status: status,
      completedAt: day.add(const Duration(hours: 8)),
      durationMinutes: 0,
      notes: '',
      xpEarned: 5,
    );

StatisticsContext _context(List<Habit> habits, List<HabitLog> logs) =>
    StatisticsContext(habits: habits, logs: logs, selectedDate: _today);

void main() {
  test('a weekly habit only counts on its days', () {
    final daily = _habit('daily');
    // Due yesterday only.
    final weekly = _habit('weekly', weekdays: [_yesterday.weekday]);

    final context = _context(
      [daily, weekly],
      [_log('daily', _yesterday), _log('weekly', _yesterday)],
    );

    expect(context.expectedHabitsForDate(_yesterday), 2);
    expect(context.completedScheduledCountForDate(_yesterday), 2);
  });

  test('archived, deleted or not-due habits do not count as completed', () {
    final daily = _habit('daily');
    final archived = _habit('old', archived: true);
    // Due on another weekday than yesterday.
    final weekly = _habit('weekly', weekdays: [_today.weekday]);

    final context = _context(
      [daily, archived, weekly],
      [
        _log('old', _yesterday),
        _log('deleted', _yesterday),
        _log('weekly', _yesterday),
      ],
    );

    // Only "daily" is due yesterday, and it was not done.
    expect(context.expectedHabitsForDate(_yesterday), 1);
    expect(context.completedScheduledCountForDate(_yesterday), 0);
  });

  test('skipped logs are not completions', () {
    final context = _context(
      [_habit('daily')],
      [_log('daily', _yesterday, status: CompletionStatus.skipped)],
    );

    expect(context.completedScheduledCountForDate(_yesterday), 0);
  });

  test('trend: a perfect day with a weekly habit is 100%, not 50%', () {
    final daily = _habit('daily');
    // Due on a different weekday than yesterday.
    final weekly = _habit('weekly', weekdays: [_today.weekday]);

    final trends = const TrendCalculator().calculate(
      _context([daily, weekly], [_log('daily', _yesterday)]),
    );

    final yesterday = trends.firstWhere((t) => t.date == _yesterday);
    expect(yesterday.completionRate, 1.0);
    expect(trends, hasLength(30));
    expect(trends.last.date, _today);
  });

  test('trend: skipped entries do not raise the rate', () {
    final trends = const TrendCalculator().calculate(
      _context(
        [_habit('a'), _habit('b')],
        [
          _log('a', _yesterday),
          _log('b', _yesterday, status: CompletionStatus.skipped),
        ],
      ),
    );

    expect(
      trends.firstWhere((t) => t.date == _yesterday).completionRate,
      0.5,
    );
  });
}
