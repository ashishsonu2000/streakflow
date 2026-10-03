import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_schedule_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/provider/filtered_habits_provider.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/provider/habit_providers.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/widgets/cards/habit_card_schedule_text.dart';

final _now = DateTime.now();
final _today = DateTime(_now.year, _now.month, _now.day);

/// Weekday numbers relative to today (1 = Monday ... 7 = Sunday).
int _weekdayIn(int days) =>
    DateTime(_today.year, _today.month, _today.day + days).weekday;

Habit _habit(
  String id, {
  HabitFrequency frequency = HabitFrequency.daily,
  List<int> weeklyDays = const [],
  int monthlyDay = 1,
  DateTime? start,
  DateTime? end,
}) {
  final s = start ?? _today.subtract(const Duration(days: 30));
  return Habit(
    id: id,
    title: id,
    frequency: frequency,
    weeklyDays: weeklyDays,
    monthlyDay: monthlyDay,
    createdAt: s,
    updatedAt: s,
    startDate: s,
    endDate: end,
  );
}

class _Repo implements HabitRepository {
  _Repo({required this.today, required this.all});

  final List<Habit> today;
  final List<Habit> all;

  @override
  Stream<List<Habit>> watchAll() => Stream.value(today);

  @override
  Stream<List<Habit>> watchAllActive() => Stream.value(all);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  group('scheduleStatus', () {
    test('a weekly habit on an off day is notToday', () {
      final habit = _habit(
        'w',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_weekdayIn(1)],
      );

      expect(habit.scheduleStatus, HabitScheduleStatus.notToday);
      expect(habit.scheduleStatus.label, 'Not due today');
    });

    test('a weekly habit on its day is active', () {
      final habit = _habit(
        'w',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_today.weekday],
      );

      expect(habit.scheduleStatus, HabitScheduleStatus.active);
    });

    test('a monthly habit on another day is notToday', () {
      final otherDay = _today.day == 1 ? 2 : 1;
      final habit = _habit(
        'm',
        frequency: HabitFrequency.monthly,
        monthlyDay: otherDay,
      );

      expect(habit.scheduleStatus, HabitScheduleStatus.notToday);
    });

    test('upcoming and expired take precedence over the weekday', () {
      final upcoming = _habit(
        'u',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_weekdayIn(1)],
        start: _today.add(const Duration(days: 10)),
      );
      final expired = _habit(
        'e',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_weekdayIn(1)],
        end: _today.subtract(const Duration(days: 1)),
      );

      expect(upcoming.scheduleStatus, HabitScheduleStatus.upcoming);
      expect(expired.scheduleStatus, HabitScheduleStatus.expired);
    });

    test('daily habits are always active within their dates', () {
      expect(_habit('d').scheduleStatus, HabitScheduleStatus.active);
    });
  });

  group('nextDueDate', () {
    test('is the next scheduled weekday', () {
      final habit = _habit(
        'w',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_weekdayIn(3)],
      );

      expect(
        habit.nextDueDate,
        DateTime(_today.year, _today.month, _today.day + 3),
      );
    });

    test('is null when the habit ends before its next day', () {
      final habit = _habit(
        'w',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_weekdayIn(3)],
        end: DateTime(_today.year, _today.month, _today.day + 1),
      );

      expect(habit.nextDueDate, isNull);
    });

    test('the card message names the next day', () {
      final habit = _habit(
        'w',
        frequency: HabitFrequency.weekly,
        weeklyDays: [_weekdayIn(3)],
      );

      expect(notDueTodayMessage(habit), startsWith('Not due today · next on '));
    });
  });

  test('the Habits page lists off-day habits; the dashboard list does not',
      () async {
    final daily = _habit('daily');
    final weekly = _habit(
      'weekly',
      frequency: HabitFrequency.weekly,
      weeklyDays: [_weekdayIn(1)],
    );

    final container = ProviderContainer(
      overrides: [
        habitRepositoryProvider.overrideWithValue(
          _Repo(today: [daily], all: [daily, weekly]),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.listen(habitsPageProvider, (_, __) {});
    container.listen(filteredHabitsProvider, (_, __) {});
    await container.read(allActiveHabitsProvider.future);
    await container.read(habitsProvider.future);

    expect(
      container.read(habitsPageProvider).value!.map((h) => h.id).toSet(),
      {'daily', 'weekly'},
    );
    expect(
      container.read(filteredHabitsProvider).value!.map((h) => h.id),
      ['daily'],
    );
  });
}
