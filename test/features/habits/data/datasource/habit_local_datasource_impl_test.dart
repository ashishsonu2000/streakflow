import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'dart:ffi';

import 'package:isar_community/src/native/isar_core.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';

import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';

import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';

void main() {
  late Directory testDirectory;
  late IsarService isarService;
  late HabitLocalDataSourceImpl dataSource;

  setUpAll(() async {
    final localAppData =
    Platform.environment['LOCALAPPDATA'];

    if (localAppData == null) {
      throw StateError(
        'LOCALAPPDATA environment variable is not available.',
      );
    }

    final isarDll = File(
      '$localAppData'
          '${Platform.pathSeparator}Pub'
          '${Platform.pathSeparator}Cache'
          '${Platform.pathSeparator}hosted'
          '${Platform.pathSeparator}pub.dev'
          '${Platform.pathSeparator}'
          'isar_community_flutter_libs-3.3.2'
          '${Platform.pathSeparator}windows'
          '${Platform.pathSeparator}'
          'libisar.dll',
    );

    if (!isarDll.existsSync()) {
      throw StateError(
        'Isar native library was not found:\n'
            '${isarDll.path}',
      );
    }

    await initializeCoreBinary(
      libraries: {
        Abi.windowsX64: isarDll.path,
      },
    );
  });

  setUp(() async {
    testDirectory =
    await Directory.systemTemp.createTemp(
      'streak_calculator_test_',
    );

    isarService = IsarService(
      directory: testDirectory.path,
      databaseName:
      'habit_test_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );

    await isarService.database;

    dataSource = HabitLocalDataSourceImpl(
      isarService,
      const HabitMapper(),
    );
  });

  tearDown(() async {
    await isarService.close();

    if (testDirectory.existsSync()) {
      await testDirectory.delete(
        recursive: true,
      );
    }
  });



  group('Habit persistence', () {
    test(
      'saves and retrieves a habit',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        final result = await dataSource.getById(
          habit.id,
        );

        expect(result, isNotNull);
        expect(result!.id, habit.id);
        expect(result.title, 'Exercise');
        expect(result.description, 'Test habit');
        expect(result.startDate, habit.startDate);
        expect(result.endDate, isNull);
      },
    );

    test(
      'getAll returns saved habits',
          () async {
        final habit1 = _createHabit(
          id: 'habit-1',
          title: 'Exercise',
        );

        final habit2 = _createHabit(
          id: 'habit-2',
          title: 'Reading',
        );

        await dataSource.save(habit1);
        await dataSource.save(habit2);

        final habits =
        await dataSource.getAll();

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
      'returns null for unknown habit',
          () async {
        final result =
        await dataSource.getById(
          'missing-habit',
        );

        expect(result, isNull);
      },
    );
  });

  // =====================================================================
  // UPDATE
  // =====================================================================

  group('Habit update', () {
    test(
      'updates an existing habit',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        final updated = habit.copyWith(
          title: 'Updated Exercise',
          description: 'Updated description',
        );

        await dataSource.save(updated);

        final result =
        await dataSource.getById(
          habit.id,
        );

        expect(result, isNotNull);
        expect(
          result!.title,
          'Updated Exercise',
        );
        expect(
          result.description,
          'Updated description',
        );
      },
    );
  });

  // =====================================================================
  // COMPLETE HABIT
  // =====================================================================

  group('Complete habit', () {
    test(
      'creates a completion log',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        final logs =
        await dataSource
            .getHabitLogsForHabit(
          habit.id,
        );

        expect(logs, hasLength(1));

        final log = logs.first;

        expect(log.habitId, habit.id);
        expect(
          log.status,
          CompletionStatus.completed,
        );
        expect(log.completedAt, isNotNull);
        expect(log.xpEarned, 5);
      },
    );

    test(
      'persists duration and notes',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
          durationMinutes: 30,
          notes: 'Morning workout',
        );

        final logs =
        await dataSource
            .getHabitLogsForHabit(
          habit.id,
        );

        expect(logs, hasLength(1));

        expect(
          logs.first.durationMinutes,
          30,
        );

        expect(
          logs.first.notes,
          'Morning workout',
        );
      },
    );

    test(
      'updates habit statistics',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        final result =
        await dataSource.getById(
          habit.id,
        );

        expect(result, isNotNull);

        expect(
          result!.totalCompleted,
          1,
        );

        expect(
          result.currentStreak,
          1,
        );

        expect(
          result.bestStreak,
          1,
        );

        expect(
          result.xp,
          5,
        );

        expect(
          result.completedToday,
          isTrue,
        );

        expect(
          result.lastCompletedDate,
          isNotNull,
        );
      },
    );

    test(
      'isCompletedToday returns true',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        expect(
          await dataSource.isCompletedToday(
            habit.id,
          ),
          isFalse,
        );

        await dataSource.completeHabit(
          habit.id,
        );

        expect(
          await dataSource.isCompletedToday(
            habit.id,
          ),
          isTrue,
        );
      },
    );

    test(
      'does not create duplicate completion',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        await dataSource.completeHabit(
          habit.id,
          durationMinutes: 60,
          notes: 'Duplicate attempt',
        );

        final logs =
        await dataSource
            .getHabitLogsForHabit(
          habit.id,
        );

        expect(logs, hasLength(1));

        final result =
        await dataSource.getById(
          habit.id,
        );

        expect(
          result!.totalCompleted,
          1,
        );

        expect(
          result.xp,
          5,
        );
      },
    );

    test(
      'throws when habit does not exist',
          () async {
        expect(
              () => dataSource.completeHabit(
            'missing-habit',
          ),
          throwsA(
            isA<Exception>().having(
                  (error) => error.toString(),
              'message',
              contains('Habit not found'),
            ),
          ),
        );
      },
    );
  });

  // =====================================================================
  // UNCOMPLETE
  // =====================================================================

  group('Uncomplete habit', () {
    test(
      'removes today completion',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        expect(
          await dataSource.isCompletedToday(
            habit.id,
          ),
          isTrue,
        );

        await dataSource.uncompleteHabit(
          habit.id,
        );

        expect(
          await dataSource.isCompletedToday(
            habit.id,
          ),
          isFalse,
        );

        final logs =
        await dataSource
            .getHabitLogsForHabit(
          habit.id,
        );

        expect(logs, isEmpty);
      },
    );

    test(
      'restores habit statistics',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        await dataSource.uncompleteHabit(
          habit.id,
        );

        final result =
        await dataSource.getById(
          habit.id,
        );

        expect(result, isNotNull);

        expect(
          result!.totalCompleted,
          0,
        );

        expect(
          result.currentStreak,
          0,
        );

        expect(
          result.xp,
          0,
        );

        expect(
          result.completedToday,
          isFalse,
        );

        expect(
          result.lastCompletedDate,
          isNull,
        );
      },
    );

    test(
      'uncomplete without completion does nothing',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.uncompleteHabit(
          habit.id,
        );

        final result =
        await dataSource.getById(
          habit.id,
        );

        expect(result, isNotNull);
        expect(
          result!.totalCompleted,
          0,
        );
        expect(result.xp, 0);
      },
    );

    test(
      'throws when habit does not exist',
          () async {
        expect(
              () => dataSource.uncompleteHabit(
            'missing-habit',
          ),
          throwsA(
            isA<Exception>().having(
                  (error) => error.toString(),
              'message',
              contains('Habit not found'),
            ),
          ),
        );
      },
    );
  });

  // =====================================================================
  // HABIT LOGS
  // =====================================================================

  group('Habit logs', () {
    test(
      'getHabitLogs returns completion logs',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        final logs =
        await dataSource.getHabitLogs();

        expect(logs, hasLength(1));
        expect(
          logs.first.habitId,
          habit.id,
        );
      },
    );

    test(
      'getHabitLogsForHabit only returns requested habit',
          () async {
        final habit1 = _createHabit(
          id: 'habit-1',
          title: 'Exercise',
        );

        final habit2 = _createHabit(
          id: 'habit-2',
          title: 'Reading',
        );

        await dataSource.save(habit1);
        await dataSource.save(habit2);

        await dataSource.completeHabit(
          habit1.id,
        );

        await dataSource.completeHabit(
          habit2.id,
        );

        final logs =
        await dataSource
            .getHabitLogsForHabit(
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
      'getHabitLogsBetween returns logs in range',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        final today = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

        final start = today.subtract(
          const Duration(days: 1),
        );

        final end = today.add(
          const Duration(days: 1),
        );

        final logs =
        await dataSource
            .getHabitLogsBetween(
          start,
          end,
        );

        expect(logs, hasLength(1));
      },
    );
  });

  // =====================================================================
  // ARCHIVE / RESTORE
  // =====================================================================

  group('Archive and restore', () {
    test(
      'archive removes habit from active habits',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        expect(
          await dataSource.getAll(),
          hasLength(1),
        );

        await dataSource.archive(
          habit.id,
        );

        expect(
          await dataSource.getAll(),
          isEmpty,
        );

        final archived =
        await dataSource
            .watchArchived()
            .first;

        expect(
          archived,
          hasLength(1),
        );

        expect(
          archived.first.id,
          habit.id,
        );
      },
    );

    test(
      'restore returns habit to active habits',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.archive(
          habit.id,
        );

        expect(
          await dataSource.getAll(),
          isEmpty,
        );

        await dataSource.restore(
          habit.id,
        );

        final habits =
        await dataSource.getAll();

        expect(
          habits,
          hasLength(1),
        );

        expect(
          habits.first.id,
          habit.id,
        );
      },
    );
  });

  // =====================================================================
  // DELETE
  // =====================================================================

  group('Delete', () {
    test(
      'delete removes habit',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        expect(
          await dataSource.getById(
            habit.id,
          ),
          isNotNull,
        );

        await dataSource.delete(
          habit.id,
        );

        expect(
          await dataSource.getById(
            habit.id,
          ),
          isNull,
        );
      },
    );

    test(
      'delete removes associated logs',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        expect(
          await dataSource
              .getHabitLogsForHabit(
            habit.id,
          ),
          hasLength(1),
        );

        await dataSource.delete(
          habit.id,
        );

        expect(
          await dataSource
              .getHabitLogsForHabit(
            habit.id,
          ),
          isEmpty,
        );
      },
    );
  });

  // =====================================================================
  // CLEAR DATABASE
  // =====================================================================

  group('Database', () {
    test(
      'clearDatabase removes habits and logs',
          () async {
        final habit = _createHabit();

        await dataSource.save(habit);

        await dataSource.completeHabit(
          habit.id,
        );

        expect(
          await dataSource.getAll(),
          isNotEmpty,
        );

        expect(
          await dataSource.getHabitLogs(),
          isNotEmpty,
        );

        await dataSource.clearDatabase();

        expect(
          await dataSource.getAll(),
          isEmpty,
        );

        expect(
          await dataSource.getHabitLogs(),
          isEmpty,
        );
      },
    );
  });
}

// =======================================================================
// TEST HABIT
// =======================================================================

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
    description: 'Test habit',
    createdAt: now,
    updatedAt: now,
    startDate: today,
    targetPerDay: 1,
    estimatedDurationMinutes: 20,
    xpReward: 5,
  );
}