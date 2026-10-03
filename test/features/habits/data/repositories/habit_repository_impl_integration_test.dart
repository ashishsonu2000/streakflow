import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/core/database/isar_service.dart';

import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/data/repositories/habit_repository_impl.dart';

import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';

import '../../../../support/isar_test_core.dart';

void main() {
  late Directory testDirectory;
  late IsarService isarService;
  late HabitLocalDataSourceImpl dataSource;
  late HabitRepositoryImpl repository;

  // =====================================================================
  // ISAR INITIALIZATION
  // =====================================================================

  setUpAll(initializeIsarTestCore);

  // =====================================================================
  // SETUP
  // =====================================================================

  setUp(() async {
    testDirectory =
    await Directory.systemTemp.createTemp(
      'streak_repository_test_',
    );

    isarService = IsarService(
      directory: testDirectory.path,
      databaseName:
      'repository_test_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );

    await isarService.database;

    dataSource = HabitLocalDataSourceImpl(
      isarService,
      const HabitMapper(),
    );

    repository = HabitRepositoryImpl(
      dataSource,
    );
  });

  // =====================================================================
  // TEARDOWN
  // =====================================================================

  tearDown(() async {
    await isarService.close();

    if (testDirectory.existsSync()) {
      await testDirectory.delete(
        recursive: true,
      );
    }
  });

  // =====================================================================
  // HABIT CRUD
  // =====================================================================

  group('HabitRepositoryImpl - Habit CRUD', () {
    test(
      'saves and retrieves a habit',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        final result =
        await repository.getById(
          habit.id,
        );

        expect(result, isNotNull);
        expect(result!.id, habit.id);
        expect(result.title, habit.title);
        expect(
          result.description,
          habit.description,
        );
        expect(
          result.startDate,
          habit.startDate,
        );
        expect(
          result.endDate,
          habit.endDate,
        );
      },
    );

    test(
      'getAll returns saved habits',
          () async {
        await repository.save(
          _createHabit(
            id: 'habit-1',
            title: 'Exercise',
          ),
        );

        await repository.save(
          _createHabit(
            id: 'habit-2',
            title: 'Reading',
          ),
        );

        final habits =
        await repository.getAll();

        expect(habits, hasLength(2));

        expect(
          habits.map((habit) => habit.id),
          containsAll([
            'habit-1',
            'habit-2',
          ]),
        );
      },
    );

    test(
      'getById returns null for missing habit',
          () async {
        final result =
        await repository.getById(
          'missing',
        );

        expect(result, isNull);
      },
    );

    test(
      'update persists changed habit',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        final updated = habit.copyWith(
          title: 'Updated Habit',
          description: 'Updated description',
        );

        await repository.update(updated);

        final result =
        await repository.getById(
          habit.id,
        );

        expect(result, isNotNull);
        expect(
          result!.title,
          'Updated Habit',
        );
        expect(
          result.description,
          'Updated description',
        );
      },
    );

    test(
      'delete removes habit',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        expect(
          await repository.getById(
            habit.id,
          ),
          isNotNull,
        );

        await repository.delete(
          habit.id,
        );

        expect(
          await repository.getById(
            habit.id,
          ),
          isNull,
        );
      },
    );
  });

  // =====================================================================
  // ARCHIVE / RESTORE
  // =====================================================================

  group('HabitRepositoryImpl - Archive', () {
    test(
      'archive removes habit from active list',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        expect(
          await repository.getAll(),
          hasLength(1),
        );

        await repository.archive(
          habit.id,
        );

        expect(
          await repository.getAll(),
          isEmpty,
        );
      },
    );

    test(
      'watchArchived returns archived habit',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.archive(
          habit.id,
        );

        final archived =
        await repository.watchArchived().first;

        expect(
          archived,
          hasLength(1),
        );

        expect(
          archived.first.id,
          habit.id,
        );

        expect(
          archived.first.archived,
          isTrue,
        );
      },
    );

    test(
      'restore returns habit to active list',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.archive(
          habit.id,
        );

        await repository.restore(
          habit.id,
        );

        final habits =
        await repository.getAll();

        expect(habits, hasLength(1));
        expect(
          habits.first.id,
          habit.id,
        );
        expect(
          habits.first.archived,
          isFalse,
        );
      },
    );
  });

  // =====================================================================
  // COMPLETION
  // =====================================================================

  group('HabitRepositoryImpl - Completion', () {
    test(
      'completeHabit creates domain log',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        final logs =
        await repository.getLogsForHabit(
          habit.id,
        );

        expect(logs, hasLength(1));

        final log = logs.first;

        expect(log, isA<HabitLog>());
        expect(log.habitId, habit.id);
        expect(log.completedAt, isNotNull);
        expect(log.xpEarned, 5);
      },
    );

    test(
      'completeHabit preserves duration and notes',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
          durationMinutes: 45,
          notes: 'Morning session',
        );

        final logs =
        await repository.getLogsForHabit(
          habit.id,
        );

        expect(logs, hasLength(1));

        expect(
          logs.first.durationMinutes,
          45,
        );

        expect(
          logs.first.notes,
          'Morning session',
        );
      },
    );

    test(
      'isCompletedToday reflects completion',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        expect(
          await repository.isCompletedToday(
            habit.id,
          ),
          isFalse,
        );

        await repository.completeHabit(
          habit.id,
        );

        expect(
          await repository.isCompletedToday(
            habit.id,
          ),
          isTrue,
        );
      },
    );

    test(
      'uncompleteHabit removes today completion',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        expect(
          await repository.isCompletedToday(
            habit.id,
          ),
          isTrue,
        );

        await repository.uncompleteHabit(
          habit.id,
        );

        expect(
          await repository.isCompletedToday(
            habit.id,
          ),
          isFalse,
        );

        final logs =
        await repository.getLogsForHabit(
          habit.id,
        );

        expect(logs, isEmpty);
      },
    );
  });

  // =====================================================================
  // LOG QUERIES
  // =====================================================================

  group('HabitRepositoryImpl - Logs', () {
    test(
      'getLogs returns domain HabitLog objects',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        final logs =
        await repository.getLogs();

        expect(logs, hasLength(1));
        expect(
          logs.first,
          isA<HabitLog>(),
        );
      },
    );

    test(
      'getLogsForHabit filters by habit',
          () async {
        final habit1 = _createHabit(
          id: 'habit-1',
          title: 'Exercise',
        );

        final habit2 = _createHabit(
          id: 'habit-2',
          title: 'Reading',
        );

        await repository.save(habit1);
        await repository.save(habit2);

        await repository.completeHabit(
          habit1.id,
        );

        await repository.completeHabit(
          habit2.id,
        );

        final logs =
        await repository.getLogsForHabit(
          habit1.id,
        );

        expect(logs, hasLength(1));
        expect(
          logs.first.habitId,
          habit1.id,
        );
      },
    );

    test(
      'getLogsBetween returns logs in range',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        final today = _today();

        final start = today.subtract(
          const Duration(days: 1),
        );

        final end = today.add(
          const Duration(days: 1),
        );

        final logs =
        await repository.getLogsBetween(
          start,
          end,
        );

        expect(logs, hasLength(1));
        expect(
          logs.first.habitId,
          habit.id,
        );
      },
    );

    test(
      'getHabitLogsForDate returns logs for date',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        final logs =
        await repository.getHabitLogsForDate(
          _today(),
        );

        expect(logs, hasLength(1));
        expect(
          logs.first.habitId,
          habit.id,
        );
      },
    );
  });

  // =====================================================================
  // STREAMS
  // =====================================================================

  group('HabitRepositoryImpl - Streams', () {
    test(
      'watchAll emits active habits',
          () async {
        final habit = _createHabit();

        final stream =
        repository.watchAll();

        await repository.save(habit);

        final habits =
        await stream.firstWhere(
              (items) => items.isNotEmpty,
        );

        expect(habits, hasLength(1));
        expect(
          habits.first.id,
          habit.id,
        );
      },
    );

    test(
      'watchLogs emits domain logs',
          () async {
        final habit = _createHabit();

        final stream =
        repository.watchLogs();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        final logs =
        await stream.firstWhere(
              (items) => items.isNotEmpty,
        );

        expect(logs, hasLength(1));
        expect(
          logs.first,
          isA<HabitLog>(),
        );
      },
    );

    test(
      'watchLogsForHabit emits logs for selected habit',
          () async {
        final habit = _createHabit();

        final stream =
        repository.watchLogsForHabit(
          habit.id,
        );

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        final logs =
        await stream.firstWhere(
              (items) => items.isNotEmpty,
        );

        expect(logs, hasLength(1));
        expect(
          logs.first.habitId,
          habit.id,
        );
      },
    );

    test(
      'watchById emits saved habit',
          () async {
        final habit = _createHabit();

        final stream =
        repository.watchById(
          habit.id,
        );

        await repository.save(habit);

        final result =
        await stream.firstWhere(
              (value) => value != null,
        );

        expect(result, isNotNull);
        expect(
          result!.id,
          habit.id,
        );
      },
    );
  });

  // =====================================================================
  // DATABASE
  // =====================================================================

  group('HabitRepositoryImpl - Database', () {
    test(
      'clearDatabase removes all data',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        expect(
          await repository.getAll(),
          isNotEmpty,
        );

        expect(
          await repository.getLogs(),
          isNotEmpty,
        );

        await repository.clearDatabase();

        expect(
          await repository.getAll(),
          isEmpty,
        );

        expect(
          await repository.getLogs(),
          isEmpty,
        );
      },
    );

    test(
      'rebuildHabitStatistics completes successfully',
          () async {
        final habit = _createHabit();

        await repository.save(habit);

        await repository.completeHabit(
          habit.id,
        );

        await expectLater(
          repository.rebuildHabitStatistics(),
          completes,
        );
      },
    );
  });
}

// =======================================================================
// HELPERS
// =======================================================================

DateTime _today() {
  final now = DateTime.now();

  return DateTime(
    now.year,
    now.month,
    now.day,
  );
}

Habit _createHabit({
  String id = 'habit-1',
  String title = 'Exercise',
}) {
  final now = DateTime.now();

  return Habit(
    id: id,
    title: title,
    description: 'Repository test habit',
    createdAt: now,
    updatedAt: now,
    startDate: _today(),
    targetPerDay: 1,
    estimatedDurationMinutes: 20,
    xpReward: 5,
  );
}