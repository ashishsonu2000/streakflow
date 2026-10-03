import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/archive_habit_usecase.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/restore_habit_usecase.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/services/notification_service.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/services/reminder_schedule.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/usecases/cancel_habit_reminder_usecase.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/usecases/schedule_habit_reminder_usecase.dart';

/// Records what would be scheduled / cancelled (no plugin).
class _FakeNotificationService implements NotificationService {
  final scheduled = <String, List<int>>{};
  final cancelled = <String>[];
  bool failCancel = false;

  @override
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitTitle,
    required List<ReminderEntry> entries,
  }) async {
    scheduled[habitId] = [for (final e in entries) e.minuteOfDay];
  }

  @override
  Future<void> cancelHabitReminder(String habitId) async {
    if (failCancel) throw StateError('plugin unavailable');
    cancelled.add(habitId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

class _FakeRepository implements HabitRepository {
  _FakeRepository(this.habit);

  Habit habit;
  final calls = <String>[];

  @override
  Future<void> archive(String id) async => calls.add('archive');

  @override
  Future<void> delete(String id) async => calls.add('delete');

  @override
  Future<void> restore(String id) async => calls.add('restore');

  @override
  Future<Habit?> getById(String id) async => habit;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Habit _habit({List<int> extras = const [720, 1260]}) {
  final now = DateTime(2026, 10, 1);
  return Habit(
    id: 'h1',
    title: 'Water',
    reminderEnabled: true,
    reminderHour: 7,
    reminderMinute: 0,
    additionalReminderMinutes: extras,
    createdAt: now,
    updatedAt: now,
    startDate: now,
  );
}

void main() {
  late _FakeNotificationService notifications;
  late _FakeRepository repository;

  setUp(() {
    notifications = _FakeNotificationService();
    repository = _FakeRepository(_habit());
  });

  group('ScheduleHabitReminderUseCase', () {
    test('free plan schedules only the primary reminder', () async {
      await ScheduleHabitReminderUseCase(
        notifications,
        maxRemindersPerHabit: () => 1,
      )(_habit());

      expect(notifications.scheduled['h1'], [420]);
    });

    test('premium plan schedules every reminder time', () async {
      await ScheduleHabitReminderUseCase(
        notifications,
        maxRemindersPerHabit: () => 5,
      )(_habit());

      expect(notifications.scheduled['h1'], [420, 720, 1260]);
    });

    test('without a plan callback it defaults to the free limit', () async {
      await ScheduleHabitReminderUseCase(notifications)(_habit());

      expect(notifications.scheduled['h1'], [420]);
    });

    test('reminder off: nothing scheduled', () async {
      final off = _habit().copyWith(reminderEnabled: false);

      await ScheduleHabitReminderUseCase(
        notifications,
        maxRemindersPerHabit: () => 5,
      )(off);

      expect(notifications.scheduled, isEmpty);
    });
  });

  group('Archive / delete / restore keep reminders consistent', () {
    CancelHabitReminderUseCase cancel() =>
        CancelHabitReminderUseCase(notifications);

    test('archive cancels the habit reminders', () async {
      await ArchiveHabitUseCase(repository, cancelReminders: cancel())('h1');

      expect(repository.calls, ['archive']);
      expect(notifications.cancelled, ['h1']);
    });

    test('delete cancels the habit reminders', () async {
      await DeleteHabitUseCase(repository, cancelReminders: cancel())('h1');

      expect(repository.calls, ['delete']);
      expect(notifications.cancelled, ['h1']);
    });

    test('a notification failure never blocks archive or delete', () async {
      notifications.failCancel = true;

      await ArchiveHabitUseCase(repository, cancelReminders: cancel())('h1');
      await DeleteHabitUseCase(repository, cancelReminders: cancel())('h1');

      expect(repository.calls, ['archive', 'delete']);
    });

    test('restore (unarchive) schedules the reminders again', () async {
      await RestoreHabitUseCase(
        repository,
        scheduleReminders: ScheduleHabitReminderUseCase(
          notifications,
          maxRemindersPerHabit: () => 5,
        ),
      )('h1');

      expect(repository.calls, ['restore']);
      expect(notifications.scheduled['h1'], [420, 720, 1260]);
    });
  });
}
