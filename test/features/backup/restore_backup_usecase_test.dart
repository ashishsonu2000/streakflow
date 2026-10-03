import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/entitlements/feature_access.dart';
import 'package:streak_calculator_flutter/features/backup/domain/services/backup_codec.dart';
import 'package:streak_calculator_flutter/features/backup/domain/usecases/restore_backup_usecase.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/profile/domain/models/app_theme_mode.dart';
import 'package:streak_calculator_flutter/features/profile/domain/models/user_profile.dart';

class _Repo implements HabitRepository {
  final events = <String>[];
  List<Habit>? habits;
  List<HabitLog>? logs;
  bool fail = false;

  @override
  Future<void> replaceAllData({
    required List<Habit> habits,
    required List<HabitLog> logs,
  }) async {
    if (fail) throw StateError('disk full');
    events.add('replace');
    this.habits = habits;
    this.logs = logs;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Habit _habit(String id, int day, {bool archived = false, bool reminder = false}) {
  final created = DateTime(2026, 9, day);
  return Habit(
    id: id,
    title: 'Habit $id',
    archived: archived,
    reminderEnabled: reminder,
    reminderHour: reminder ? 7 : null,
    reminderMinute: reminder ? 0 : null,
    createdAt: created,
    updatedAt: created,
    startDate: created,
  );
}

BackupContents _contents(List<Habit> habits, {BackupProfile? profile}) =>
    BackupContents(
      formatVersion: 2,
      exportedAt: null,
      profile: profile,
      habits: habits,
      logs: [
        HabitLog(
          id: '1',
          habitId: habits.first.id,
          date: DateTime(2026, 9, 10),
          status: CompletionStatus.completed,
          completedAt: DateTime(2026, 9, 10, 8),
          durationMinutes: 0,
          notes: '',
          xpEarned: 5,
        ),
      ],
      skippedHabits: 0,
      skippedLogs: 0,
    );

const _current = UserProfile(
  name: 'Current',
  notificationsEnabled: false,
  onboardingCompleted: true,
  goals: [],
  themeMode: AppThemeMode.light,
);

void main() {
  late _Repo repo;
  late List<String> scheduled;
  late UserProfile? saved;

  RestoreBackupUseCase useCase({bool premium = false}) {
    return RestoreBackupUseCase(
      repository: repo,
      access: () => FeatureAccess(isPremium: premium),
      loadProfile: () async => _current,
      saveProfile: (profile) async => saved = profile,
      cancelAllReminders: () async => repo.events.add('cancel'),
      scheduleReminder: (habit) async => scheduled.add(habit.id),
      now: () => DateTime(2026, 10, 1),
    );
  }

  setUp(() {
    repo = _Repo();
    scheduled = [];
    saved = null;
  });

  // Seven active habits, created on days 1..7, plus one archived.
  final seven = [
    for (var day = 1; day <= 7; day++) _habit('h$day', day, reminder: true),
    _habit('archived', 8, archived: true, reminder: true),
  ];

  test('Free plan: the oldest 5 stay active, newer ones are archived',
      () async {
    final result = await useCase()(_contents(seven));

    final active = repo.habits!.where((h) => !h.archived).map((h) => h.id);
    expect(active, ['h1', 'h2', 'h3', 'h4', 'h5']);
    expect(result.archivedForLimit, ['Habit h6', 'Habit h7']);
    // Nothing is deleted.
    expect(repo.habits, hasLength(8));
    expect(result.habits, 8);
  });

  test('the longest-running habits stay active, not the newest records',
      () async {
    // Re-created records (late createdAt) of habits started long ago.
    Habit started(String id, int startDay, int createdDay) => Habit(
          id: id,
          title: id,
          createdAt: DateTime(2026, 9, createdDay),
          updatedAt: DateTime(2026, 9, createdDay),
          startDate: DateTime(2026, 9, startDay),
        );

    await useCase()(_contents([
      started('new-1', 20, 20),
      started('new-2', 21, 21),
      for (var i = 1; i <= 4; i++) started('long-$i', 1, 28),
    ]));

    expect(
      repo.habits!.where((h) => !h.archived).map((h) => h.id).toSet(),
      {'long-1', 'long-2', 'long-3', 'long-4', 'new-1'},
    );
  });

  test('the preview lists the same habits as the restore archives', () {
    expect(
      useCase().habitsOverLimit(_contents(seven)).map((h) => h.id),
      ['h6', 'h7'],
    );
    expect(useCase(premium: true).habitsOverLimit(_contents(seven)), isEmpty);
  });

  test('Premium restores every habit as it was', () async {
    final result = await useCase(premium: true)(_contents(seven));

    expect(repo.habits!.where((h) => !h.archived), hasLength(7));
    expect(result.archivedForLimit, isEmpty);
  });

  test('data is replaced before old reminders are cancelled, and only '
      'active habits with reminders are rescheduled', () async {
    await useCase()(_contents(seven));

    expect(repo.events, ['replace', 'cancel']);
    expect(scheduled, ['h1', 'h2', 'h3', 'h4', 'h5']);
    expect(repo.logs, hasLength(1));
  });

  test('a failed write changes nothing: no cancel, no profile, rethrows',
      () async {
    repo.fail = true;

    await expectLater(
      useCase()(_contents(seven,
          profile: const BackupProfile(
            name: 'Backup',
            goals: [],
            notificationsEnabled: true,
            themeMode: AppThemeMode.dark,
          ))),
      throwsStateError,
    );

    expect(repo.events, isEmpty);
    expect(scheduled, isEmpty);
    expect(saved, isNull);
  });

  test('profile is restored but onboarding stays completed', () async {
    await useCase()(_contents(
      [_habit('a', 1)],
      profile: const BackupProfile(
        name: 'Backup name',
        goals: ['Sleep'],
        notificationsEnabled: true,
        themeMode: AppThemeMode.dark,
      ),
    ));

    expect(saved!.name, 'Backup name');
    expect(saved!.goals, ['Sleep']);
    expect(saved!.themeMode, AppThemeMode.dark);
    expect(saved!.notificationsEnabled, isTrue);
    expect(saved!.onboardingCompleted, isTrue);
  });

  test('an empty profile name keeps the current one', () async {
    await useCase()(_contents(
      [_habit('a', 1)],
      profile: const BackupProfile(
        name: '',
        goals: [],
        notificationsEnabled: false,
        themeMode: AppThemeMode.system,
      ),
    ));

    expect(saved!.name, 'Current');
  });

  test('a failing reminder does not fail the restore', () async {
    final failing = RestoreBackupUseCase(
      repository: repo,
      access: () => const FeatureAccess(isPremium: true),
      loadProfile: () async => _current,
      saveProfile: (_) async {},
      cancelAllReminders: () async {},
      scheduleReminder: (_) async => throw StateError('no permission'),
    );

    final result = await failing(_contents(seven));

    expect(result.reminderFailures, 7);
    expect(repo.habits, hasLength(8));
  });
}
