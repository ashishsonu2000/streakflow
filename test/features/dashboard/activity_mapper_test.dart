import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/dashboard/domain/builders/activity_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';

Habit _habit(String id, String title) => Habit(
      id: id,
      title: title,
      createdAt: DateTime(2026, 9, 1),
      updatedAt: DateTime(2026, 9, 1),
      startDate: DateTime(2026, 9, 1),
    );

HabitLog _log(String habitId, int day) => HabitLog(
      id: '$habitId-$day',
      habitId: habitId,
      date: DateTime(2026, 9, day),
      status: CompletionStatus.completed,
      completedAt: DateTime(2026, 9, day, 8),
      durationMinutes: 0,
      notes: '',
      xpEarned: 5,
    );

void main() {
  const mapper = ActivityMapper();

  test('each completion shows its habit name', () {
    final items = mapper.map(
      habits: [_habit('meditate', 'Meditate'), _habit('water', 'Drink Water')],
      logs: [_log('meditate', 28), _log('water', 29)],
    );

    expect(items.map((item) => item.title), ['Drink Water', 'Meditate']);
  });

  test('completions of habits that no longer exist are left out', () {
    final items = mapper.map(
      habits: [_habit('water', 'Drink Water')],
      logs: [_log('gone', 28), _log('water', 27)],
    );

    expect(items.map((item) => item.title), ['Drink Water']);
  });

  test('keeps only the latest completions, newest first', () {
    final items = mapper.map(
      habits: [_habit('water', 'Drink Water')],
      logs: [for (var day = 1; day <= 25; day++) _log('water', day)],
    );

    expect(items, hasLength(ActivityMapper.recentLimit));
    expect(items.first.date, DateTime(2026, 9, 25, 8));
    expect(items.last.date, DateTime(2026, 9, 16, 8));
  });
}
