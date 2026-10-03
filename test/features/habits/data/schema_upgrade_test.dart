import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:streak_calculator_flutter/core/database/collections/profile_collection.dart';
import 'package:streak_calculator_flutter/core/database/entities/database_metadata.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';
import 'package:streak_calculator_flutter/features/habits/data/datasource/habit_local_datasource_impl.dart';
import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/data/mapper/habit_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';

import '../../../support/isar_test_core.dart';
import '../../../support/legacy/legacy_habit_entity.dart';
import '../../../support/legacy/legacy_habit_log_entity.dart';

/// Real upgrade path: data written by the PREVIOUS schema (no
/// additionalReminderMinutes) is opened by the CURRENT app schema.
void main() {
  late Directory directory;
  const name = 'upgrade_test';

  setUpAll(initializeIsarTestCore);

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('schema_upgrade_');
  });

  tearDown(() async {
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  });

  Future<void> writeWithPreviousSchema() async {
    final isar = await Isar.open(
      [
        LegacyHabitEntitySchema,
        LegacyHabitLogEntitySchema,
        DatabaseMetadataSchema,
        ProfileCollectionSchema,
      ],
      directory: directory.path,
      name: name,
      inspector: false,
    );

    final start = DateTime(2026, 9, 2);
    final titles = [
      'Morning walk',
      'Morning Run',
      'Read 20 Pages',
      'Drink Water',
      'Meditate',
    ];

    await isar.writeTxn(() async {
      for (var i = 0; i < titles.length; i++) {
        final habit = LegacyHabitEntity()
          ..uuid = 'uuid-$i'
          ..title = titles[i]
          ..frequency =
              titles[i] == 'Meditate' ? HabitFrequency.weekly : HabitFrequency.daily
          ..weeklyDays = titles[i] == 'Meditate' ? [1, 3, 5] : []
          ..reminderEnabled = i == 0
          ..reminderHour = i == 0 ? 18 : null
          ..reminderMinute = i == 0 ? 53 : null
          ..currentStreak = i
          ..bestStreak = 29
          ..totalCompleted = 9
          ..xp = 45
          ..startDate = start
          ..createdAt = start
          ..updatedAt = start;

        await isar.legacyHabitEntitys.put(habit);

        for (var d = 0; d < 9; d++) {
          final log = LegacyHabitLogEntity()
            ..habitId = 'uuid-$i'
            ..date = start.add(Duration(days: d))
            ..status = CompletionStatus.completed
            ..xpEarned = 5;
          await isar.legacyHabitLogEntitys.put(log);
        }
      }
    });

    expect(await isar.legacyHabitEntitys.count(), 5);
    await isar.close();
  }

  test('every habit and log written by the previous version survives',
      () async {
    await writeWithPreviousSchema();

    // Open exactly as the app does now.
    final service = IsarService(
      directory: directory.path,
      databaseName: name,
      inspector: false,
    );
    addTearDown(service.close);

    final dataSource = HabitLocalDataSourceImpl(service, const HabitMapper());

    // All active habits (getAll() filters to today's schedule).
    final habits = await dataSource.getAllForCalendar();
    final logs = await (await service.database).habitLogEntitys.count();

    expect(habits.map((h) => h.title).toSet(), {
      'Morning walk',
      'Morning Run',
      'Read 20 Pages',
      'Drink Water',
      'Meditate',
    });
    expect(logs, 45);

    final walk = habits.firstWhere((h) => h.title == 'Morning walk');
    expect(walk.reminderEnabled, isTrue);
    expect(walk.reminderHour, 18);
    expect(walk.reminderMinute, 53);

    final meditate = habits.firstWhere((h) => h.title == 'Meditate');
    expect(meditate.frequency, HabitFrequency.weekly);
    expect(meditate.weeklyDays, [1, 3, 5]);
    expect(meditate.bestStreak, 29);
    expect(meditate.xp, 45);

    // The new field reads back empty for old records.
    expect(habits.every((h) => h.additionalReminderMinutes.isEmpty), isTrue);
  });

  test('upgraded records can be updated with the new field', () async {
    await writeWithPreviousSchema();

    final service = IsarService(
      directory: directory.path,
      databaseName: name,
      inspector: false,
    );
    addTearDown(service.close);
    final dataSource = HabitLocalDataSourceImpl(service, const HabitMapper());

    final walk =
        (await dataSource.getAllForCalendar()).firstWhere((h) => h.title == 'Morning walk');
    await dataSource.save(walk.copyWith(additionalReminderMinutes: [720]));

    final habits = await dataSource.getAllForCalendar();
    expect(habits, hasLength(5));
    expect(
      habits.firstWhere((h) => h.title == 'Morning walk').additionalReminderMinutes,
      [720],
    );
  });
}
