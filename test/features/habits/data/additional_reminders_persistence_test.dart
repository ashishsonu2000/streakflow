import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';
import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';

import '../../../support/isar_test_core.dart';

/// Real Isar database (native library), not a mock.
void main() {
  late Directory directory;
  late IsarService isar;
  late HabitLocalDataSourceImpl dataSource;

  setUpAll(initializeIsarTestCore);

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('reminders_test_');
    isar = IsarService(
      directory: directory.path,
      databaseName: 'reminders_${DateTime.now().microsecondsSinceEpoch}',
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

  Habit habit(String id, {List<int> extras = const []}) {
    final now = DateTime(2026, 10, 1);
    return Habit(
      id: id,
      title: 'Habit $id',
      reminderEnabled: true,
      reminderHour: 7,
      reminderMinute: 30,
      additionalReminderMinutes: extras,
      createdAt: now,
      updatedAt: now,
      startDate: now,
    );
  }

  test('a habit without extra reminders reads back an empty list and an '
      'unchanged primary reminder', () async {
    await dataSource.save(habit('plain'));

    final loaded = (await dataSource.getAll()).single;

    expect(loaded.additionalReminderMinutes, isEmpty);
    expect(loaded.reminderEnabled, isTrue);
    expect(loaded.reminderHour, 7);
    expect(loaded.reminderMinute, 30);
  });

  test('extra reminder times persist and update', () async {
    await dataSource.save(habit('multi', extras: [720, 1260]));

    var loaded = (await dataSource.getAll()).single;
    expect(loaded.additionalReminderMinutes, [720, 1260]);

    await dataSource.save(loaded.copyWith(additionalReminderMinutes: [900]));

    loaded = (await dataSource.getAll()).single;
    expect(loaded.additionalReminderMinutes, [900]);
  });
}
