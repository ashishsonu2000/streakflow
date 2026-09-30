import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/entitlements/feature_access.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/create_habit_request.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/domain/services/habit_limit_guard.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/create_habit_usecase.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/restore_habit_usecase.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/usecases/schedule_habit_reminder_usecase.dart';
import 'package:streak_calculator_flutter/features/onboarding/domain/models/suggested_habit.dart';
import 'package:streak_calculator_flutter/features/onboarding/domain/usecases/create_suggested_habit_usecase.dart';

/// In-memory repository: only what the guarded use cases touch.
class _FakeRepository implements HabitRepository {
  _FakeRepository(this.habits);

  final List<Habit> habits;
  final List<String> restoredIds = [];

  @override
  Future<List<Habit>> getAll() async =>
      habits.where((h) => !h.archived).toList();

  @override
  Future<void> save(Habit habit) async => habits.add(habit);

  @override
  Future<void> restore(String id) async => restoredIds.add(id);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

class _NoopReminder implements ScheduleHabitReminderUseCase {
  @override
  Future<void> call(Habit habit) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

Habit _habit(String id, {bool archived = false}) {
  final now = DateTime(2026, 9, 30);
  return Habit(
    id: id,
    title: 'Habit $id',
    archived: archived,
    createdAt: now,
    updatedAt: now,
    startDate: now,
  );
}

List<Habit> _active(int count) =>
    List.generate(count, (i) => _habit('a$i'));

void main() {
  const limit = PremiumConfig.freeHabitLimit;

  HabitLimitGuard guardFor(
    _FakeRepository repo, {
    required bool premium,
  }) {
    return HabitLimitGuard(
      countActiveHabits: () async => (await repo.getAll()).length,
      access: () => FeatureAccess(isPremium: premium),
    );
  }

  group('HabitLimitGuard', () {
    test('free: allowed below the limit, blocked at the limit', () async {
      expect(
        await guardFor(_FakeRepository(_active(limit - 1)), premium: false)
            .canAddActiveHabit(),
        isTrue,
      );
      expect(
        await guardFor(_FakeRepository(_active(limit)), premium: false)
            .canAddActiveHabit(),
        isFalse,
      );
    });

    test('archived habits do not count toward the limit', () async {
      final repo = _FakeRepository([
        ..._active(limit - 1),
        _habit('x1', archived: true),
        _habit('x2', archived: true),
      ]);

      expect(await guardFor(repo, premium: false).canAddActiveHabit(),
          isTrue);
    });

    test('premium: unlimited, without counting', () async {
      var counted = false;
      final guard = HabitLimitGuard(
        countActiveHabits: () async {
          counted = true;
          return 999;
        },
        access: () => const FeatureAccess(isPremium: true),
      );

      expect(await guard.canAddActiveHabit(), isTrue);
      expect(counted, isFalse);
    });

    test('ensureCanAddActiveHabit throws with the configured limit',
        () async {
      final guard =
          guardFor(_FakeRepository(_active(limit)), premium: false);

      await expectLater(
        guard.ensureCanAddActiveHabit(),
        throwsA(
          isA<HabitLimitReachedException>()
              .having((e) => e.limit, 'limit', limit)
              .having((e) => e.message, 'message', contains('$limit')),
        ),
      );
    });
  });

  group('Guarded use cases', () {
    CreateHabitRequest request() => CreateHabitRequest(
          title: 'New habit',
          startDate: DateTime(2026, 9, 30),
        );

    test('CreateHabitUseCase: blocked at the limit, nothing saved',
        () async {
      final repo = _FakeRepository(_active(limit));
      final useCase = CreateHabitUseCase(
        repo,
        _NoopReminder(),
        limitGuard: guardFor(repo, premium: false),
      );

      await expectLater(
        useCase(request()),
        throwsA(isA<HabitLimitReachedException>()),
      );
      expect(repo.habits, hasLength(limit));
    });

    test('CreateHabitUseCase: allowed below the limit', () async {
      final repo = _FakeRepository(_active(limit - 1));
      final useCase = CreateHabitUseCase(
        repo,
        _NoopReminder(),
        limitGuard: guardFor(repo, premium: false),
      );

      await useCase(request());

      expect(repo.habits, hasLength(limit));
    });

    test('CreateHabitUseCase: premium can exceed the free limit', () async {
      final repo = _FakeRepository(_active(limit + 5));
      final useCase = CreateHabitUseCase(
        repo,
        _NoopReminder(),
        limitGuard: guardFor(repo, premium: true),
      );

      await useCase(request());

      expect(repo.habits, hasLength(limit + 6));
    });

    test('RestoreHabitUseCase (unarchive): blocked at the limit', () async {
      final repo = _FakeRepository([
        ..._active(limit),
        _habit('archived', archived: true),
      ]);
      final useCase = RestoreHabitUseCase(
        repo,
        limitGuard: guardFor(repo, premium: false),
      );

      await expectLater(
        useCase('archived'),
        throwsA(isA<HabitLimitReachedException>()),
      );
      expect(repo.restoredIds, isEmpty);
    });

    test('RestoreHabitUseCase: allowed below the limit', () async {
      final repo = _FakeRepository([
        ..._active(limit - 1),
        _habit('archived', archived: true),
      ]);

      await RestoreHabitUseCase(
        repo,
        limitGuard: guardFor(repo, premium: false),
      )('archived');

      expect(repo.restoredIds, ['archived']);
    });

    test('CreateSuggestedHabitUseCase (onboarding): blocked at the limit',
        () async {
      final repo = _FakeRepository(_active(limit));
      final useCase = CreateSuggestedHabitUseCase(
        repo,
        limitGuard: guardFor(repo, premium: false),
      );

      await expectLater(
        useCase.execute(
          const SuggestedHabit(
            title: 'Drink water',
            description: '',
            category: 'health',
          ),
        ),
        throwsA(isA<HabitLimitReachedException>()),
      );
      expect(repo.habits, hasLength(limit));
    });
  });
}
