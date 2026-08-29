import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/complete_habit_usecase.dart';

class _FakeHabitRepository implements HabitRepository {
  _FakeHabitRepository({
    this.habit,
  });

  Habit? habit;

  String? completedHabitId;
  int? completedDurationMinutes;
  String? completedNotes;

  int completeHabitCalls = 0;

  // ===============================================================
  // HABIT CRUD
  // ===============================================================

  @override
  Future<List<Habit>> getAll() async {
    return habit == null ? [] : [habit!];
  }

  @override
  Stream<List<Habit>> watchAll() {
    return Stream.value(
      habit == null ? [] : [habit!],
    );
  }

  @override
  Future<Habit?> getById(
      String id,
      ) async {
    if (habit?.id == id) {
      return habit;
    }

    return null;
  }

  @override
  Future<void> save(
      Habit habit,
      ) async {
    this.habit = habit;
  }

  @override
  Future<void> update(
      Habit habit,
      ) async {
    this.habit = habit;
  }

  @override
  Future<void> delete(
      String id,
      ) async {
    if (habit?.id == id) {
      habit = null;
    }
  }

  @override
  Future<void> archive(
      String id,
      ) async {}

  @override
  Future<void> restore(
      String id,
      ) async {}

  @override
  Stream<List<Habit>> watchArchived() {
    return Stream.value([]);
  }

  // ===============================================================
  // HABIT COMPLETION
  // ===============================================================

  @override
  Future<void> completeHabit(
      String habitId, {
        int durationMinutes = 0,
        String notes = '',
      }) async {
    completeHabitCalls++;

    completedHabitId = habitId;
    completedDurationMinutes =
        durationMinutes;
    completedNotes = notes;
  }

  @override
  Future<void> uncompleteHabit(
      String habitId,
      ) async {}

  @override
  Future<bool> isCompletedToday(
      String habitId,
      ) async {
    return false;
  }

  // ===============================================================
  // ENTITY LOG APIs
  // ===============================================================

  @override
  Future<List<HabitLogEntity>> getHabitLogs() async {
    return [];
  }

  @override
  Future<List<HabitLogEntity>>
  getHabitLogsForHabit(
      String habitId,
      ) async {
    return [];
  }

  @override
  Future<List<HabitLogEntity>>
  getHabitLogsBetween(
      DateTime start,
      DateTime end,
      ) async {
    return [];
  }

  @override
  Stream<List<HabitLogEntity>>
  watchHabitLogs() {
    return Stream.value([]);
  }

  // ===============================================================
  // STATISTICS / LOG APIs
  // ===============================================================

  @override
  Future<void> rebuildHabitStatistics() async {}

  @override
  Future<List<HabitLog>> getLogs() async {
    return [];
  }

  @override
  Future<List<HabitLog>> getLogsForHabit(
      String habitId,
      ) async {
    return [];
  }

  @override
  Future<List<HabitLog>> getLogsBetween(
      DateTime start,
      DateTime end,
      ) async {
    return [];
  }

  @override
  Stream<List<HabitLog>> watchLogs() {
    return Stream.value([]);
  }

  @override
  Future<List<HabitLogEntity>>
  getHabitLogsForDate(
      DateTime date,
      ) async {
    return [];
  }

  @override
  Stream<List<HabitLog>>
  watchLogsForHabit(
      String habitId,
      ) {
    return Stream.value([]);
  }

  @override
  Stream<Habit?> watchById(
      String id,
      ) {
    return Stream.value(
      habit?.id == id ? habit : null,
    );
  }

  @override
  Future<void> clearDatabase() async {}
}

// =====================================================================
// HABIT FACTORY
// =====================================================================

Habit _habit({
  String id = 'habit-1',
  DateTime? startDate,
  DateTime? endDate,
}) {
  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  return Habit(
    id: id,
    title: 'Exercise',
    createdAt: now,
    updatedAt: now,
    startDate:
    startDate ?? today,
    endDate: endDate,
  );
}

// =====================================================================
// TESTS
// =====================================================================

void main() {
  group(
    'CompleteHabitUseCase',
        () {
      // =============================================================
      // SUCCESS
      // =============================================================

      test(
        'completes an active habit',
            () async {
          final habit = _habit();

          final repository =
          _FakeHabitRepository(
            habit: habit,
          );

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          await useCase(
            habit.id,
          );

          expect(
            repository.completeHabitCalls,
            1,
          );

          expect(
            repository.completedHabitId,
            habit.id,
          );

          expect(
            repository.completedDurationMinutes,
            0,
          );

          expect(
            repository.completedNotes,
            '',
          );
        },
      );

      // =============================================================
      // PARAMETERS
      // =============================================================

      test(
        'passes duration and notes to repository',
            () async {
          final habit = _habit();

          final repository =
          _FakeHabitRepository(
            habit: habit,
          );

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          await useCase(
            habit.id,
            durationMinutes: 30,
            notes: 'Morning workout',
          );

          expect(
            repository.completedHabitId,
            habit.id,
          );

          expect(
            repository.completedDurationMinutes,
            30,
          );

          expect(
            repository.completedNotes,
            'Morning workout',
          );
        },
      );

      // =============================================================
      // HABIT NOT FOUND
      // =============================================================

      test(
        'throws when habit does not exist',
            () async {
          final repository =
          _FakeHabitRepository();

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          expect(
                () => useCase(
              'missing-habit',
            ),
            throwsA(
              isA<Exception>().having(
                    (error) =>
                    error.toString(),
                'message',
                contains(
                  'Habit not found.',
                ),
              ),
            ),
          );

          expect(
            repository.completeHabitCalls,
            0,
          );
        },
      );

      // =============================================================
      // START DATE
      // =============================================================

      test(
        'throws when habit has not started',
            () async {
          final tomorrow =
          DateTime.now().add(
            const Duration(days: 1),
          );

          final tomorrowOnly =
          DateTime(
            tomorrow.year,
            tomorrow.month,
            tomorrow.day,
          );

          final repository =
          _FakeHabitRepository(
            habit: _habit(
              startDate:
              tomorrowOnly,
            ),
          );

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          expect(
                () => useCase(
              repository.habit!.id,
            ),
            throwsA(
              isA<Exception>().having(
                    (error) =>
                    error.toString(),
                'message',
                contains(
                  'This habit has not started yet.',
                ),
              ),
            ),
          );

          expect(
            repository.completeHabitCalls,
            0,
          );
        },
      );

      // =============================================================
      // END DATE
      // =============================================================

      test(
        'throws when habit has already ended',
            () async {
          final yesterday =
          DateTime.now().subtract(
            const Duration(days: 1),
          );

          final yesterdayOnly =
          DateTime(
            yesterday.year,
            yesterday.month,
            yesterday.day,
          );

          final repository =
          _FakeHabitRepository(
            habit: _habit(
              startDate:
              yesterdayOnly.subtract(
                const Duration(days: 7),
              ),
              endDate:
              yesterdayOnly,
            ),
          );

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          expect(
                () => useCase(
              repository.habit!.id,
            ),
            throwsA(
              isA<Exception>().having(
                    (error) =>
                    error.toString(),
                'message',
                contains(
                  'This habit has already ended.',
                ),
              ),
            ),
          );

          expect(
            repository.completeHabitCalls,
            0,
          );
        },
      );

      // =============================================================
      // END DATE = TODAY
      // =============================================================

      test(
        'allows completion on the habit end date',
            () async {
          final today =
          DateTime.now();

          final todayOnly =
          DateTime(
            today.year,
            today.month,
            today.day,
          );

          final repository =
          _FakeHabitRepository(
            habit: _habit(
              startDate:
              todayOnly.subtract(
                const Duration(days: 7),
              ),
              endDate:
              todayOnly,
            ),
          );

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          await useCase(
            repository.habit!.id,
          );

          expect(
            repository.completeHabitCalls,
            1,
          );
        },
      );

      // =============================================================
      // START DATE = TODAY
      // =============================================================

      test(
        'allows completion when habit starts today',
            () async {
          final today =
          DateTime.now();

          final todayOnly =
          DateTime(
            today.year,
            today.month,
            today.day,
          );

          final repository =
          _FakeHabitRepository(
            habit: _habit(
              startDate:
              todayOnly,
            ),
          );

          final useCase =
          CompleteHabitUseCase(
            repository,
          );

          await useCase(
            repository.habit!.id,
          );

          expect(
            repository.completeHabitCalls,
            1,
          );
        },
      );
    },
  );
}