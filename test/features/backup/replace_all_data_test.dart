import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';
import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/mood_type.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';

import '../../support/isar_test_core.dart';

/// Real Isar database (native library), not a mock.
void main() {
  late Directory directory;
  late IsarService isar;
  late HabitLocalDataSourceImpl dataSource;

  setUpAll(initializeIsarTestCore);

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('restore_test_');
    isar = IsarService(
      directory: directory.path,
      databaseName: 'restore_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
    await isar.database;
    dataSource = HabitLocalDataSourceImpl(isar, const HabitMapper());
  });

  tearDown(() async {
    await isar.close();
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  });

  final start = DateTime(2026, 9, 1);

  Habit habit(String id, {bool archived = false}) => Habit(
        id: id,
        title: 'Habit $id',
        frequency: HabitFrequency.weekly,
        weeklyDays: const [2, 4],
        endDate: DateTime(2027, 3, 1),
        archived: archived,
        bestStreak: 9,
        createdAt: start,
        updatedAt: start,
        startDate: start,
      );

  test('replaces every habit and log; fields survive', () async {
    // Existing data that must disappear.
    await dataSource.save(habit('old'));
    await dataSource.completeHabit('old');
    expect(await dataSource.getHabitLogs(), isNotEmpty);

    await dataSource.replaceAllData(
      habits: [habit('a'), habit('b', archived: true)],
      logs: [
        HabitLog(
          id: '99',
          habitId: 'a',
          date: DateTime(2026, 9, 3),
          status: CompletionStatus.skipped,
          completedAt: DateTime(2026, 9, 3, 21, 5),
          durationMinutes: 12,
          notes: 'rainy',
          xpEarned: 0,
          mood: MoodType.bad,
        ),
      ],
    );

    final habits = await dataSource.getAllIncludingArchived();
    expect(habits.map((h) => h.id).toSet(), {'a', 'b'});

    final a = habits.firstWhere((h) => h.id == 'a');
    expect(a.weeklyDays, [2, 4]);
    expect(a.endDate, DateTime(2027, 3, 1));
    expect(a.bestStreak, 9);
    expect(habits.firstWhere((h) => h.id == 'b').archived, isTrue);

    final logs = await dataSource.getHabitLogs();
    expect(logs, hasLength(1));
    final log = logs.single;
    expect(log.habitId, 'a');
    expect(log.date, DateTime(2026, 9, 3));
    expect(log.status, CompletionStatus.skipped);
    expect(log.completedAt, DateTime(2026, 9, 3, 21, 5));
    expect(log.durationMinutes, 12);
    expect(log.notes, 'rainy');
    expect(log.mood, MoodType.bad);
  });
}
