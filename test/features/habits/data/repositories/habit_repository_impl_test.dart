import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource.dart';
import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';

class _FakeHabitLocalDataSource
    implements HabitLocalDataSource {
  List<Habit> habits = [];

  List<HabitLogEntity> logs = [];

  String? lastCompletedHabitId;
  int? lastDurationMinutes;
  String? lastNotes;

  String? lastUncompletedHabitId;

  String? lastCheckedHabitId;

  String? lastArchivedHabitId;
  String? lastRestoredHabitId;
  String? lastDeletedHabitId;

  String? lastWatchHabitId;

  DateTime? lastRangeStart;
  DateTime? lastRangeEnd;

  Habit? watchedHabit;

  int completeHabitCalls = 0;
  int uncompleteHabitCalls = 0;
  int clearDatabaseCalls = 0;
  int rebuildStatisticsCalls = 0;

  bool completedToday = false;

  // ===============================================================
  // HABITS
  // ===============================================================

  @override
  Future<List<Habit>> getAll() async {
    return habits;
  }

  @override
  Future<Habit?> getById(
      String id,
      ) async {
    for (final habit in habits) {
      if (habit.id == id) {
        return habit;
      }
    }

    return null;
  }

  @override
  Stream<List<Habit>> watchAll() {
    return Stream.value(habits);
  }

  @override
  Future<void> save(
      Habit habit,
      ) async {
    habits.removeWhere(
          (item) => item.id == habit.id,
    );

    habits.add(habit);
  }

  @override
  Future<void> delete(
      String id,
      ) async {
    lastDeletedHabitId = id;

    habits.removeWhere(
          (habit) => habit.id == id,
    );
  }

  @override
  Future<void> archive(
      String id,
      ) async {
    lastArchivedHabitId = id;
  }

  @override
  Future<void> restore(
      String id,
      ) async {
    lastRestoredHabitId = id;
  }

  @override
  Stream<List<Habit>> watchArchived() {
    return Stream.value(
      habits.where(
            (habit) => habit.archived,
      ).toList(),
    );
  }

  // ===============================================================
  // COMPLETION
  // ===============================================================

  @override
  Future<void> completeHabit(
      String habitId, {
        int durationMinutes = 0,
        String notes = '',
      }) async {
    completeHabitCalls++;

    lastCompletedHabitId = habitId;
    lastDurationMinutes =
        durationMinutes;
    lastNotes = notes;

    completedToday = true;
  }

  @override
  Future<bool> isCompletedToday(
      String habitId,
      ) async {
    lastCheckedHabitId = habitId;

    return completedToday;
  }

  @override
  Future<void> uncompleteHabit(
      String habitId,
      ) async {
    uncompleteHabitCalls++;

    lastUncompletedHabitId = habitId;

    completedToday = false;
  }

  // ===============================================================
  // LOGS
  // ===============================================================

  @override
  Future<List<HabitLogEntity>>
  getHabitLogs() async {
    return logs;
  }

  @override
  Future<List<HabitLogEntity>>
  getHabitLogsBetween(
      DateTime start,
      DateTime end,
      ) async {
    lastRangeStart = start;
    lastRangeEnd = end;

    return logs.where(
          (log) {
        return !log.date.isBefore(start) &&
            log.date.isBefore(end);
      },
    ).toList();
  }

  @override
  Future<List<HabitLogEntity>>
  getHabitLogsForHabit(
      String habitId,
      ) async {
    return logs.where(
          (log) => log.habitId == habitId,
    ).toList();
  }

  @override
  Stream<List<HabitLogEntity>>
  watchHabitLogs() {
    return Stream.value(logs);
  }

  @override
  Stream<List<HabitLogEntity>>
  watchHabitLogsForHabit(
      String habitId,
      ) {
    lastWatchHabitId = habitId;

    return Stream.value(
      logs.where(
            (log) => log.habitId == habitId,
      ).toList(),
    );
  }

  // ===============================================================
  // STATISTICS
  // ===============================================================

  @override
  Future<void> rebuildHabitStatistics() async {
    rebuildStatisticsCalls++;
  }

  // ===============================================================
  // WATCH HABIT
  // ===============================================================

  @override
  Stream<Habit?> watchById(
      String id,
      ) {
    return Stream.value(
      watchedHabit?.id == id
          ? watchedHabit
          : null,
    );
  }

  // ===============================================================
  // DATABASE
  // ===============================================================

  @override
  Future<void> clearDatabase() async {
    clearDatabaseCalls++;

    habits.clear();
    logs.clear();
  }
}

// =====================================================================
// TEST DATA
// =====================================================================

Habit _createHabit({
  String id = 'habit-1',
  String title = 'Exercise',
}) {
  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  return Habit(
    id: id,
    title: title,
    createdAt: now,
    updatedAt: now,
    startDate: today,
  );
}

HabitLogEntity _createLog({
  String habitId = 'habit-1',
  DateTime? date,
  int xp = 10,
}) {
  final log = HabitLogEntity();

  log.habitId = habitId;

  log.date =
      date ??
          DateTime.now();

  log.status =
      CompletionStatus.completed;

  log.completedAt = log.date;

  log.durationMinutes = 20;

  log.xpEarned = xp;

  log.notes = 'Test log';

  return log;
}

// =====================================================================
// TESTS
// =====================================================================

void main() {
  late _FakeHabitLocalDataSource dataSource;
  late HabitRepositoryImpl repository;

  setUp(() {
    dataSource =
        _FakeHabitLocalDataSource();

    repository =
        HabitRepositoryImpl(
          dataSource,
        );
  });

  // ===================================================================
  // HABIT CRUD
  // ===================================================================

  group(
    'Habit CRUD',
        () {
      test(
        'getAll delegates to data source',
            () async {
          final habit =
          _createHabit();

          dataSource.habits = [
            habit,
          ];

          final result =
          await repository.getAll();

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first.id,
            habit.id,
          );
        },
      );

      test(
        'getById delegates to data source',
            () async {
          final habit =
          _createHabit();

          dataSource.habits = [
            habit,
          ];

          final result =
          await repository.getById(
            habit.id,
          );

          expect(
            result,
            isNotNull,
          );

          expect(
            result!.id,
            habit.id,
          );
        },
      );

      test(
        'save delegates to data source',
            () async {
          final habit =
          _createHabit();

          await repository.save(
            habit,
          );

          expect(
            dataSource.habits,
            contains(habit),
          );
        },
      );

      test(
        'update delegates to save',
            () async {
          final habit =
          _createHabit();

          await repository.update(
            habit,
          );

          expect(
            dataSource.habits,
            contains(habit),
          );
        },
      );

      test(
        'delete delegates to data source',
            () async {
          await repository.delete(
            'habit-1',
          );

          expect(
            dataSource.lastDeletedHabitId,
            'habit-1',
          );
        },
      );

      test(
        'archive delegates to data source',
            () async {
          await repository.archive(
            'habit-1',
          );

          expect(
            dataSource.lastArchivedHabitId,
            'habit-1',
          );
        },
      );

      test(
        'restore delegates to data source',
            () async {
          await repository.restore(
            'habit-1',
          );

          expect(
            dataSource.lastRestoredHabitId,
            'habit-1',
          );
        },
      );
    },
  );

  // ===================================================================
  // COMPLETION
  // ===================================================================

  group(
    'Habit completion',
        () {
      test(
        'completeHabit delegates all parameters',
            () async {
          await repository.completeHabit(
            'habit-1',
            durationMinutes: 30,
            notes: 'Morning exercise',
          );

          expect(
            dataSource.completeHabitCalls,
            1,
          );

          expect(
            dataSource.lastCompletedHabitId,
            'habit-1',
          );

          expect(
            dataSource.lastDurationMinutes,
            30,
          );

          expect(
            dataSource.lastNotes,
            'Morning exercise',
          );
        },
      );

      test(
        'completeHabit uses default parameters',
            () async {
          await repository.completeHabit(
            'habit-1',
          );

          expect(
            dataSource.lastCompletedHabitId,
            'habit-1',
          );

          expect(
            dataSource.lastDurationMinutes,
            0,
          );

          expect(
            dataSource.lastNotes,
            '',
          );
        },
      );

      test(
        'isCompletedToday delegates correctly',
            () async {
          dataSource.completedToday =
          true;

          final result =
          await repository
              .isCompletedToday(
            'habit-1',
          );

          expect(
            result,
            isTrue,
          );

          expect(
            dataSource.lastCheckedHabitId,
            'habit-1',
          );
        },
      );

      test(
        'uncompleteHabit delegates correctly',
            () async {
          await repository
              .uncompleteHabit(
            'habit-1',
          );

          expect(
            dataSource.uncompleteHabitCalls,
            1,
          );

          expect(
            dataSource.lastUncompletedHabitId,
            'habit-1',
          );
        },
      );
    },
  );

  // ===================================================================
  // LOGS
  // ===================================================================

  group(
    'Habit logs',
        () {
      test(
        'getHabitLogs returns entity logs',
            () async {
          final log =
          _createLog();

          dataSource.logs = [
            log,
          ];

          final result =
          await repository
              .getHabitLogs();

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first.habitId,
            'habit-1',
          );

          expect(
            result.first.xpEarned,
            10,
          );
        },
      );

      test(
        'getHabitLogsForHabit delegates habit id',
            () async {
          dataSource.logs = [
            _createLog(
              habitId: 'habit-1',
            ),
            _createLog(
              habitId: 'habit-2',
            ),
          ];

          final result =
          await repository
              .getHabitLogsForHabit(
            'habit-1',
          );

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first.habitId,
            'habit-1',
          );
        },
      );

      test(
        'getHabitLogsBetween delegates date range',
            () async {
          final start =
          DateTime(2026, 8, 1);

          final end =
          DateTime(2026, 8, 10);

          dataSource.logs = [
            _createLog(
              date:
              DateTime(2026, 8, 5),
            ),
          ];

          final result =
          await repository
              .getHabitLogsBetween(
            start,
            end,
          );

          expect(
            result,
            hasLength(1),
          );

          expect(
            dataSource.lastRangeStart,
            start,
          );

          expect(
            dataSource.lastRangeEnd,
            end,
          );
        },
      );

      test(
        'getHabitLogsForDate filters a single day',
            () async {
          final target =
          DateTime(2026, 8, 15);

          dataSource.logs = [
            _createLog(
              date:
              DateTime(2026, 8, 15, 10),
            ),
            _createLog(
              date:
              DateTime(2026, 8, 16),
            ),
          ];

          final result =
          await repository
              .getHabitLogsForDate(
            target,
          );

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first.date.day,
            15,
          );
        },
      );
    },
  );

  // ===================================================================
  // DOMAIN LOG MAPPING
  // ===================================================================

  group(
    'Domain log mapping',
        () {
      test(
        'getLogs maps entities to domain models',
            () async {
          dataSource.logs = [
            _createLog(
              xp: 25,
            ),
          ];

          final result =
          await repository.getLogs();

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first,
            isA<HabitLog>(),
          );

          expect(
            result.first.habitId,
            'habit-1',
          );

          expect(
            result.first.xpEarned,
            25,
          );

          expect(
            result.first.durationMinutes,
            20,
          );

          expect(
            result.first.notes,
            'Test log',
          );
        },
      );

      test(
        'getLogsForHabit maps entities to domain models',
            () async {
          dataSource.logs = [
            _createLog(
              habitId: 'habit-1',
            ),
            _createLog(
              habitId: 'habit-2',
            ),
          ];

          final result =
          await repository
              .getLogsForHabit(
            'habit-1',
          );

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first,
            isA<HabitLog>(),
          );

          expect(
            result.first.habitId,
            'habit-1',
          );
        },
      );

      test(
        'getLogsBetween maps entities to domain models',
            () async {
          dataSource.logs = [
            _createLog(
              date:
              DateTime(2026, 8, 5),
            ),
          ];

          final result =
          await repository
              .getLogsBetween(
            DateTime(2026, 8, 1),
            DateTime(2026, 8, 10),
          );

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first,
            isA<HabitLog>(),
          );
        },
      );
    },
  );

  // ===================================================================
  // STREAMS
  // ===================================================================

  group(
    'Streams',
        () {
      test(
        'watchAll delegates to data source',
            () async {
          final habit =
          _createHabit();

          dataSource.habits = [
            habit,
          ];

          final result =
          await repository
              .watchAll()
              .first;

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first.id,
            habit.id,
          );
        },
      );

      test(
        'watchArchived returns archived habits',
            () async {
          final habit =
          _createHabit();

          dataSource.habits = [
            habit,
          ];

          final result =
          await repository
              .watchArchived()
              .first;

          expect(
            result,
            isEmpty,
          );
        },
      );

      test(
        'watchHabitLogs returns entity logs',
            () async {
          dataSource.logs = [
            _createLog(),
          ];

          final result =
          await repository
              .watchHabitLogs()
              .first;

          expect(
            result,
            hasLength(1),
          );
        },
      );

      test(
        'watchLogs maps entities to domain models',
            () async {
          dataSource.logs = [
            _createLog(
              xp: 50,
            ),
          ];

          final result =
          await repository
              .watchLogs()
              .first;

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first,
            isA<HabitLog>(),
          );

          expect(
            result.first.xpEarned,
            50,
          );
        },
      );

      test(
        'watchLogsForHabit filters and maps logs',
            () async {
          dataSource.logs = [
            _createLog(
              habitId: 'habit-1',
            ),
            _createLog(
              habitId: 'habit-2',
            ),
          ];

          final result =
          await repository
              .watchLogsForHabit(
            'habit-1',
          )
              .first;

          expect(
            result,
            hasLength(1),
          );

          expect(
            result.first.habitId,
            'habit-1',
          );
        },
      );

      test(
        'watchById delegates to data source',
            () async {
          final habit =
          _createHabit();

          dataSource.watchedHabit =
              habit;

          final result =
          await repository
              .watchById(
            habit.id,
          )
              .first;

          expect(
            result,
            isNotNull,
          );

          expect(
            result!.id,
            habit.id,
          );
        },
      );
    },
  );

  // ===================================================================
  // DATABASE / STATISTICS
  // ===================================================================

  group(
    'Database operations',
        () {
      test(
        'rebuildHabitStatistics delegates',
            () async {
          await repository
              .rebuildHabitStatistics();

          expect(
            dataSource
                .rebuildStatisticsCalls,
            1,
          );
        },
      );

      test(
        'clearDatabase delegates',
            () async {
          await repository
              .clearDatabase();

          expect(
            dataSource
                .clearDatabaseCalls,
            1,
          );
        },
      );
    },
  );
}