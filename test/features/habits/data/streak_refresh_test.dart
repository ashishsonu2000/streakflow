import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';
import 'package:streak_calculator_flutter/features/habits/data/entities/habit_entity.dart';
import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/domain/services/habit_statistics_rebuilder.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/providers/habit_repository_provider.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/providers/streak_refresh_provider.dart';

import '../../../support/isar_test_core.dart';

/// Real Isar database (native library), not a mock.
void main() {
  late Directory directory;
  late IsarService service;
  late Isar db;

  final today = DateTime(2026, 10, 2);
  final start = DateTime(2026, 9, 1);
  final edited = DateTime(2026, 9, 15, 10);

  setUpAll(initializeIsarTestCore);

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('streak_refresh_');
    service = IsarService(
      directory: directory.path,
      databaseName: 'streaks_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
    db = await service.database;
  });

  tearDown(() async {
    await service.close();
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  });

  Future<void> seed(String id, {required int stored, required List<int> daysAgo}) async {
    await db.writeTxn(() async {
      await db.habitEntitys.put(
        HabitEntity()
          ..uuid = id
          ..title = id
          ..startDate = start
          ..createdAt = start
          ..updatedAt = edited
          ..currentStreak = stored
          ..bestStreak = stored,
      );
      for (final ago in daysAgo) {
        final day = DateTime(today.year, today.month, today.day - ago);
        await db.habitLogEntitys.put(
          HabitLogEntity()
            ..habitId = id
            ..date = day
            ..status = CompletionStatus.completed
            ..completedAt = day.add(const Duration(hours: 8)),
        );
      }
    });
  }

  Future<HabitEntity> load(String id) async =>
      (await db.habitEntitys.filter().uuidEqualTo(id).findFirst())!;

  test('a missed day lowers a stale stored streak; up-to-date habits are '
      'not rewritten; updatedAt untouched', () async {
    // Stored 3 from the last completion, but yesterday was missed.
    await seed('missed', stored: 3, daysAgo: [4, 3, 2]);
    // Stored 2 and still correct (done the last two days, today open).
    await seed('current', stored: 2, daysAgo: [2, 1]);

    final changed =
        await const HabitStatisticsRebuilder().refreshStreaks(db, today: today);

    expect(changed, 1);

    final missed = await load('missed');
    expect(missed.currentStreak, 0);
    expect(missed.bestStreak, 3);
    expect(missed.updatedAt, edited);

    final current = await load('current');
    expect(current.currentStreak, 2);
    expect(current.updatedAt, edited);
  });

  test('completedToday follows the date', () async {
    await seed('done-today', stored: 1, daysAgo: [0]);

    await const HabitStatisticsRebuilder().refreshStreaks(db, today: today);
    expect((await load('done-today')).completedToday, isTrue);

    // Next day: no longer completed "today", streak still alive.
    await const HabitStatisticsRebuilder().refreshStreaks(
      db,
      today: today.add(const Duration(days: 1)),
    );
    final next = await load('done-today');
    expect(next.completedToday, isFalse);
    expect(next.currentStreak, 1);
  });

  test('the refresher runs once per calendar day', () async {
    final repo = _CountingRepo();
    var now = DateTime(2026, 10, 2, 8);

    final container = ProviderContainer(
      overrides: [
        habitRepositoryProvider.overrideWithValue(repo),
        streakRefresherProvider.overrideWith(
          (ref) => StreakRefresher(ref, now: () => now),
        ),
      ],
    );
    addTearDown(container.dispose);

    final refresher = container.read(streakRefresherProvider);

    await refresher.refreshIfNewDay();
    now = DateTime(2026, 10, 2, 22);
    await refresher.refreshIfNewDay();
    expect(repo.refreshes, 1);

    now = DateTime(2026, 10, 3, 7);
    await refresher.refreshIfNewDay();
    expect(repo.refreshes, 2);
  });
}

class _CountingRepo implements HabitRepository {
  int refreshes = 0;

  @override
  Future<int> refreshStreaks() async {
    refreshes++;
    return 0;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}
