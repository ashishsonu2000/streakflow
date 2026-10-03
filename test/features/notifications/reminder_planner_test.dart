import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/services/notification_service.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/services/reminder_schedule.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/usecases/schedule_habit_reminder_usecase.dart';
import 'package:streak_calculator_flutter/features/notifications/presentation/providers/reminder_entitlement_sync.dart';

/// Thursday 1 October 2026, 10:00.
final _now = DateTime(2026, 10, 1, 10);

Habit _habit({
  HabitFrequency frequency = HabitFrequency.daily,
  List<int> weeklyDays = const [],
  int monthlyDay = 1,
  DateTime? start,
  DateTime? end,
  List<int> extras = const [],
}) {
  return Habit(
    id: 'h1',
    title: 'Habit',
    frequency: frequency,
    weeklyDays: weeklyDays,
    monthlyDay: monthlyDay,
    reminderEnabled: true,
    reminderHour: 7,
    reminderMinute: 0,
    additionalReminderMinutes: extras,
    createdAt: DateTime(2026, 9, 1),
    updatedAt: DateTime(2026, 9, 1),
    startDate: start ?? DateTime(2026, 9, 1),
    endDate: end,
  );
}

List<ReminderEntry> _plan(Habit habit, List<int> times) =>
    ReminderPlanner.plan(habit, times, now: _now);

/// 07:00, 12:00 and 21:00.
const _threeTimes = [420, 720, 1260];

class _RecordingService implements NotificationService {
  List<ReminderEntry>? entries;

  @override
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required List<ReminderEntry> entries,
  }) async {
    this.entries = entries;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  group('daily habits', () {
    test('one daily repeat per reminder time, next occurrence first', () {
      final entries = _plan(_habit(), _threeTimes);

      expect(entries.map((e) => e.repeat).toSet(), {ReminderRepeat.daily});
      // 07:00 has passed at 10:00, so it starts tomorrow; the others
      // still fire today.
      expect(entries.map((e) => e.at), [
        DateTime(2026, 10, 2, 7),
        DateTime(2026, 10, 1, 12),
        DateTime(2026, 10, 1, 21),
      ]);
      expect(entries.map((e) => e.id),
          [for (var s = 0; s < 3; s++) ReminderIds.recurring('h1', s)]);
    });

    test('custom habits (scheduled every day) repeat daily', () {
      final entries =
          _plan(_habit(frequency: HabitFrequency.custom), const [720]);

      expect(entries.single.repeat, ReminderRepeat.daily);
    });

    test('a future start date delays the first reminder', () {
      final entries =
          _plan(_habit(start: DateTime(2026, 10, 20)), const [720]);

      expect(entries.single.at, DateTime(2026, 10, 20, 12));
    });
  });

  group('weekly habits', () {
    test('remind only on the selected weekdays', () {
      // Monday, Wednesday, Friday.
      final entries = _plan(
        _habit(frequency: HabitFrequency.weekly, weeklyDays: [1, 3, 5]),
        const [720],
      );

      expect(entries.map((e) => e.repeat).toSet(), {ReminderRepeat.weekly});
      expect(entries.map((e) => e.at), [
        DateTime(2026, 10, 5, 12), // Monday
        DateTime(2026, 10, 7, 12), // Wednesday
        DateTime(2026, 10, 2, 12), // Friday
      ]);
      expect(entries.map((e) => e.at.weekday), [1, 3, 5]);
    });

    test('one alarm per weekday and reminder time, all with unique ids', () {
      final entries = _plan(
        _habit(frequency: HabitFrequency.weekly, weeklyDays: [1, 3, 5]),
        _threeTimes,
      );

      expect(entries, hasLength(9));
      expect(entries.map((e) => e.id).toSet(), hasLength(9));
    });

    test("today's weekday whose time has passed starts next week", () {
      // Thursday 07:00, it's Thursday 10:00.
      final entries = _plan(
        _habit(frequency: HabitFrequency.weekly, weeklyDays: [4]),
        const [420],
      );

      expect(entries.single.at, DateTime(2026, 10, 8, 7));
    });

    test('every day of the week repeats daily (fewer alarms)', () {
      final entries = _plan(
        _habit(
          frequency: HabitFrequency.weekly,
          weeklyDays: [1, 2, 3, 4, 5, 6, 7],
        ),
        const [720],
      );

      expect(entries.single.repeat, ReminderRepeat.daily);
    });

    test('older weekly habits without weekdays use the start weekday', () {
      // Started on a Monday.
      final entries = _plan(
        _habit(
          frequency: HabitFrequency.weekly,
          start: DateTime(2026, 9, 28),
        ),
        const [720],
      );

      expect(entries.single.at, DateTime(2026, 10, 5, 12));
      expect(entries.single.repeat, ReminderRepeat.weekly);
    });
  });

  group('monthly habits', () {
    test('remind on the day of the month', () {
      final entries = _plan(
        _habit(frequency: HabitFrequency.monthly, monthlyDay: 15),
        const [720],
      );

      expect(entries.single.at, DateTime(2026, 10, 15, 12));
      expect(entries.single.repeat, ReminderRepeat.monthly);
    });

    test('the 31st skips months without one', () {
      final entries = ReminderPlanner.plan(
        _habit(frequency: HabitFrequency.monthly, monthlyDay: 31),
        const [720],
        now: DateTime(2026, 11, 1, 10),
      );

      // No 31 November: next is 31 December.
      expect(entries.single.at, DateTime(2026, 12, 31, 12));
    });

    test('an invalid day schedules nothing', () {
      expect(
        _plan(_habit(frequency: HabitFrequency.monthly, monthlyDay: 0),
            const [720]),
        isEmpty,
      );
    });
  });

  group('habits with an end date', () {
    test('a long end date still uses one repeat per time (no alarm flood)',
        () {
      final entries = _plan(
        _habit(end: DateTime(2027, 10, 1)),
        [..._threeTimes, 900, 1080],
      );

      // Previously: one alarm per day per time, ~1,800 for a year.
      expect(entries, hasLength(5));
      expect(entries.every((e) => e.repeat == ReminderRepeat.daily), isTrue);
    });

    test('in the final occurrences, exact one-offs up to the end date', () {
      final entries = _plan(
        _habit(end: DateTime(2026, 10, 3)),
        const [420, 1260],
      );

      expect(entries.every((e) => e.repeat == ReminderRepeat.none), isTrue);
      expect(entries.map((e) => e.at), [
        // Today's 07:00 has passed.
        DateTime(2026, 10, 1, 21),
        DateTime(2026, 10, 2, 7),
        DateTime(2026, 10, 2, 21),
        DateTime(2026, 10, 3, 7),
        DateTime(2026, 10, 3, 21),
      ]);
      expect(entries.map((e) => e.id).toSet(), hasLength(5));
    });

    test('final-day one-offs follow the weekly schedule', () {
      // Ends next Thursday; Monday and Wednesday only.
      final entries = _plan(
        _habit(
          frequency: HabitFrequency.weekly,
          weeklyDays: [1, 3],
          end: DateTime(2026, 10, 8),
        ),
        const [720],
      );

      expect(entries.map((e) => e.at), [
        DateTime(2026, 10, 5, 12),
        DateTime(2026, 10, 7, 12),
      ]);
    });

    test('final one-off alarms are bounded', () {
      final entries = _plan(
        _habit(end: DateTime(2026, 10, 7)),
        [..._threeTimes, 900, 1080],
      );

      expect(entries.length,
          lessThanOrEqualTo(ReminderPlanner.finalOccurrences * 5));
    });

    test('a monthly habit ending this month fires once, not monthly', () {
      // Monthly on the 5th, ends on the 20th: a monthly repeat would
      // remind again on 5 November, after the end.
      final entries = _plan(
        _habit(
          frequency: HabitFrequency.monthly,
          monthlyDay: 5,
          end: DateTime(2026, 10, 20),
        ),
        const [720],
      );

      expect(entries.single.at, DateTime(2026, 10, 5, 12));
      expect(entries.single.repeat, ReminderRepeat.none);
    });

    test('a weekly habit with few weeks left gets exact one-offs', () {
      // Mondays only, ends in ~4 weeks: 4 occurrences left.
      final entries = _plan(
        _habit(
          frequency: HabitFrequency.weekly,
          weeklyDays: [1],
          end: DateTime(2026, 10, 30),
        ),
        const [720],
      );

      expect(entries.map((e) => e.at), [
        DateTime(2026, 10, 5, 12),
        DateTime(2026, 10, 12, 12),
        DateTime(2026, 10, 19, 12),
        DateTime(2026, 10, 26, 12),
      ]);
      expect(entries.every((e) => e.repeat == ReminderRepeat.none), isTrue);
    });

    test('a monthly habit with many months left repeats monthly', () {
      final entries = _plan(
        _habit(
          frequency: HabitFrequency.monthly,
          monthlyDay: 5,
          end: DateTime(2027, 12, 31),
        ),
        const [720],
      );

      expect(entries.single.repeat, ReminderRepeat.monthly);
    });

    test('an ended habit schedules nothing', () {
      expect(_plan(_habit(end: DateTime(2026, 9, 30)), const [720]),
          isEmpty);
    });
  });

  test('no reminder times, no reminders', () {
    expect(_plan(_habit(), const []), isEmpty);
  });

  test('weekly ids are stable and distinct from other reminder ids', () {
    expect(ReminderIds.weekly('h1', 1, 0), ReminderIds.weekly('h1', 1, 0));
    expect(ReminderIds.weekly('h1', 1, 0),
        isNot(ReminderIds.weekly('h1', 2, 0)));
    expect(ReminderIds.weekly('h1', 1, 0),
        isNot(ReminderIds.weekly('h1', 1, 1)));
    expect(ReminderIds.weekly('h1', 1, 0),
        isNot(ReminderIds.recurring('h1', 0)));
  });

  test('end-dated habits are refreshed at every launch', () {
    expect(needsSync(_habit()), isFalse);
    expect(needsSync(_habit(end: DateTime(2027, 1, 1))), isTrue);
    expect(needsSync(_habit(extras: [720])), isTrue);
  });

  test('the use case schedules the planned reminders', () async {
    final service = _RecordingService();
    final useCase = ScheduleHabitReminderUseCase(
      service,
      maxRemindersPerHabit: () => 5,
      now: () => _now,
    );

    await useCase(
      _habit(
        frequency: HabitFrequency.weekly,
        weeklyDays: [1, 3, 5],
        extras: [1260],
      ),
    );

    expect(service.entries, hasLength(6));
    expect(service.entries!.every((e) => e.repeat == ReminderRepeat.weekly),
        isTrue);
  });
}
