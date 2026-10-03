import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';
import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';

import '../../../support/isar_test_core.dart';

/// Real Isar database. Undo after delete must bring back the habit's
/// completion history, not only the habit (deleting removes the logs).
void main() {
  late Directory directory;
  late IsarService isar;
  late HabitRepositoryImpl repository;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  setUpAll(initializeIsarTestCore);

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('undo_delete_test_');
    isar = IsarService(
      directory: directory.path,
      databaseName: 'undo_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
    await isar.database;
    repository = HabitRepositoryImpl(
      HabitLocalDataSourceImpl(isar, const HabitMapper()),
    );

    final start = today.subtract(const Duration(days: 10));
    await repository.save(Habit(
      id: 'water',
      title: 'Drink Water',
      createdAt: start,
      updatedAt: start,
      startDate: start,
    ));
    await repository.completeHabit('water', date: yesterday);
    await repository.completeHabit('water', date: today);
  });

  tearDown(() async {
    await isar.close();
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  });

  test('restoring a deleted habit brings back its history', () async {
    final habit = (await repository.getById('water'))!;
    final logs = await repository.getLogsForHabit('water');
    expect(logs, hasLength(2));

    await repository.delete('water');
    expect(await repository.getById('water'), isNull);
    expect(await repository.getLogsForHabit('water'), isEmpty);

    await repository.restoreDeleted(habit: habit, logs: logs);

    final restored = (await repository.getById('water'))!;
    expect(restored.currentStreak, 2);
    expect(restored.totalCompleted, 2);
    expect(restored.completedToday, isTrue);

    final restoredLogs = await repository.getLogsForHabit('water');
    expect(
      restoredLogs.map((log) => log.date).toSet(),
      {today, yesterday},
    );
  });
}
