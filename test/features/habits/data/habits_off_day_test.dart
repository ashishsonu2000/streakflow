import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';
import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';

import '../../../support/isar_test_core.dart';

/// Real Isar database (native library), not a mock.
///
/// Weekly/monthly habits must stay reachable on the days they are not
/// due: the Habits page, statistics and backups need every habit, while
/// the dashboard keeps today's list.
void main() {
  late Directory directory;
  late IsarService isar;
  late HabitLocalDataSourceImpl dataSource;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // A weekday that is not today, so the weekly habit is off today.
  final offDay = today.weekday % 7 + 1;

  setUpAll(initializeIsarTestCore);

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('off_day_test_');
    isar = IsarService(
      directory: directory.path,
      databaseName: 'off_day_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
    await isar.database;
    dataSource = HabitLocalDataSourceImpl(isar, const HabitMapper());

    final start = today.subtract(const Duration(days: 30));

    await dataSource.save(Habit(
      id: 'daily',
      title: 'Daily',
      createdAt: start,
      updatedAt: start,
      startDate: start,
    ));
    await dataSource.save(Habit(
      id: 'weekly-off',
      title: 'Weekly (off today)',
      frequency: HabitFrequency.weekly,
      weeklyDays: [offDay],
      createdAt: start,
      updatedAt: start,
      startDate: start,
    ));
    await dataSource.save(Habit(
      id: 'archived',
      title: 'Archived',
      archived: true,
      createdAt: start,
      updatedAt: start,
      startDate: start,
    ));
  });

  tearDown(() async {
    await isar.close();
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  });

  Set<String> ids(List<Habit> habits) => habits.map((h) => h.id).toSet();

  test("today's list (dashboard) still only has habits due today", () async {
    expect(ids(await dataSource.getAll()), {'daily'});
    expect(ids(await dataSource.watchAll().first), {'daily'});
  });

  test('the Habits page sees every active habit, also off-day ones',
      () async {
    expect(
      ids(await dataSource.watchAllActive().first),
      {'daily', 'weekly-off'},
    );
  });

  test('statistics source has every active habit', () async {
    expect(
      ids(await dataSource.getAllForCalendar()),
      {'daily', 'weekly-off'},
    );
  });

  test('backups include every habit, archived too', () async {
    expect(
      ids(await dataSource.getAllIncludingArchived()),
      {'daily', 'weekly-off', 'archived'},
    );
  });

  test('completion flags still work in the full list', () async {
    await dataSource.completeHabit('daily');

    final habits = await dataSource.watchAllActive().first;
    final byId = {for (final h in habits) h.id: h};

    expect(byId['daily']!.completedToday, isTrue);
    expect(byId['weekly-off']!.completedToday, isFalse);
  });
}
