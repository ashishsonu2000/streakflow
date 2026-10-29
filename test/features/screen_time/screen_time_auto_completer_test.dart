import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/screen_time/domain/screen_time_auto_completer.dart';
import 'package:streak_calculator_flutter/features/screen_time/domain/screen_time_limits.dart';

// Thursday 29 October 2026, 10:00.
final _now = DateTime(2026, 10, 29, 10);

Habit _detox({
  String id = 'detox',
  int? limit = 120,
  DateTime? start,
  bool archived = false,
  HabitFrequency frequency = HabitFrequency.daily,
  List<int> weeklyDays = const [],
}) =>
    Habit(
      id: id,
      title: 'Digital detox',
      screenTimeLimitMinutes: limit,
      archived: archived,
      frequency: frequency,
      weeklyDays: weeklyDays,
      createdAt: DateTime(2026, 10, 1),
      updatedAt: DateTime(2026, 10, 1),
      startDate: start ?? DateTime(2026, 10, 1),
    );

void main() {
  group('ScreenTimeAutoCompleter.run', () {
    late Map<DateTime, int?> usage;
    late Set<String> completedKeys;
    late List<String> completedCalls;
    late List<DateTime> queried;

    ScreenTimeAutoCompleter completer() => ScreenTimeAutoCompleter(
          clock: () => _now,
          minutesOn: (day) async {
            queried.add(day);
            return usage[day];
          },
          isCompletedOn: (id, day) async =>
              completedKeys.contains('$id ${day.toIso8601String()}'),
          complete: (id, day) async {
            completedCalls.add('$id ${day.day}');
          },
        );

    setUp(() {
      usage = {
        DateTime(2026, 10, 28): 90, // under 2h
        DateTime(2026, 10, 27): 150, // over
        DateTime(2026, 10, 26): null, // no data
      };
      completedKeys = {};
      completedCalls = [];
      queried = [];
    });

    test('completes past days under the limit only, never today', () async {
      final count = await completer().run([_detox()]);

      expect(completedCalls, ['detox 28']);
      expect(count, 1);
      expect(queried, isNot(contains(DateTime(2026, 10, 29))));
    });

    test('a day exactly at the limit is not completed', () async {
      usage[DateTime(2026, 10, 28)] = 120;

      await completer().run([_detox()]);

      expect(completedCalls, isEmpty);
    });

    test('skips days already completed and days before the start', () async {
      completedKeys.add('detox ${DateTime(2026, 10, 28).toIso8601String()}');

      await completer().run([_detox()]);
      expect(completedCalls, isEmpty);

      await completer().run([_detox(id: 'new', start: DateTime(2026, 10, 29))]);
      expect(completedCalls, isEmpty);
    });

    test('ignores regular and archived habits', () async {
      await completer().run([
        _detox(id: 'regular', limit: null),
        _detox(id: 'archived', archived: true),
      ]);

      expect(completedCalls, isEmpty);
      expect(queried, isEmpty);
    });

    test('respects the schedule and reads each day once', () async {
      await completer().run([
        // Wednesday 28 Oct only.
        _detox(
          id: 'wed',
          frequency: HabitFrequency.weekly,
          weeklyDays: const [3],
        ),
        // Tuesday 27 Oct only (over the limit that day).
        _detox(
          id: 'tue',
          frequency: HabitFrequency.weekly,
          weeklyDays: const [2],
        ),
        _detox(id: 'daily', limit: 60),
      ]);

      expect(completedCalls, ['wed 28']);
      expect(queried.toSet().length, queried.length);
    });
  });

  group('ScreenTimeAutoCompleter.alertsFor', () {
    test('lists the scheduled days of each active limit habit', () {
      final alerts = ScreenTimeAutoCompleter.alertsFor(
        [
          _detox(),
          _detox(
            id: 'weekdays',
            limit: 60,
            frequency: HabitFrequency.weekly,
            weeklyDays: const [6, 7],
          ),
          _detox(id: 'regular', limit: null),
          _detox(id: 'archived', archived: true),
        ],
        now: _now,
        days: 7,
      );

      expect(alerts.map((a) => a.habitId), ['detox', 'weekdays']);
      expect(alerts.first.days, [
        '2026-10-29',
        '2026-10-30',
        '2026-10-31',
        '2026-11-01',
        '2026-11-02',
        '2026-11-03',
        '2026-11-04',
      ]);
      expect(alerts.last.days, ['2026-10-31', '2026-11-01']);
      expect(alerts.last.toMap()['limitMinutes'], 60);
    });

    test('leaves out habits with no scheduled day ahead', () {
      final alerts = ScreenTimeAutoCompleter.alertsFor(
        [_detox(start: DateTime(2027, 1, 1))],
        now: _now,
      );

      expect(alerts, isEmpty);
    });
  });

  test('ScreenTimeLimits.format', () {
    expect(ScreenTimeLimits.format(45), '45m');
    expect(ScreenTimeLimits.format(120), '2h');
    expect(ScreenTimeLimits.format(90), '1h 30m');
    expect(ScreenTimeLimits.warningMinutes(120), 96);
  });
}
