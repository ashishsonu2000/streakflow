import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/providers/habit_repository_provider.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/usecases/schedule_habit_reminder_usecase.dart';
import 'package:streak_calculator_flutter/features/notifications/presentation/providers/notification_usecase_provider.dart';
import 'package:streak_calculator_flutter/features/notifications/presentation/providers/reminder_entitlement_sync.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class _Repo implements HabitRepository {
  _Repo(this.habits);
  final List<Habit> habits;

  @override
  Future<List<Habit>> getAllForCalendar() async => habits;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

class _RecordingSchedule implements ScheduleHabitReminderUseCase {
  final scheduled = <String>[];

  @override
  Future<void> call(Habit habit) async => scheduled.add(habit.id);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Habit _habit(String id,
    {bool reminder = true, List<int> extras = const [], HabitFrequency? f}) {
  final now = DateTime(2026, 10, 1);
  return Habit(
    id: id,
    title: id,
    frequency: f ?? HabitFrequency.daily,
    reminderEnabled: reminder,
    reminderHour: 7,
    reminderMinute: 0,
    additionalReminderMinutes: extras,
    createdAt: now,
    updatedAt: now,
    startDate: now,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('legacy device timezone names resolve (no UTC fallback)', () {
    tzdata.initializeTimeZones();

    expect(tz.getLocation('Asia/Calcutta').name, 'Asia/Calcutta');
    expect(tz.getLocation('Asia/Kolkata').name, 'Asia/Kolkata');
  });

  group('reminder sync', () {
    late _RecordingSchedule schedule;

    Future<ProviderContainer> start(
      List<Habit> habits, {
      Map<String, Object> prefs = const {},
    }) async {
      SharedPreferences.setMockInitialValues(prefs);
      final instance = await SharedPreferences.getInstance();
      schedule = _RecordingSchedule();

      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(instance),
          habitRepositoryProvider.overrideWithValue(_Repo(habits)),
          scheduleHabitReminderUseCaseProvider.overrideWithValue(schedule),
        ],
      );
      addTearDown(c.dispose);

      c.read(reminderEntitlementSyncProvider);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return c;
    }

    final habits = [
      _habit('daily'),
      _habit('weekly-not-today', f: HabitFrequency.weekly),
      _habit('with-extras', extras: [720]),
      _habit('no-reminder', reminder: false),
    ];

    test('first launch after the update reschedules every reminder once',
        () async {
      await start(habits);

      expect(schedule.scheduled,
          ['daily', 'weekly-not-today', 'with-extras']);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('reminder_schedule_version'),
          reminderScheduleVersion);
    });

    test('later launches only resync habits with extra times', () async {
      await start(
        habits,
        prefs: {'reminder_schedule_version': reminderScheduleVersion},
      );

      expect(schedule.scheduled, ['with-extras']);
    });
  });
}
