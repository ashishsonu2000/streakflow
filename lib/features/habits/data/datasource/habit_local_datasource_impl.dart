import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_service.dart';
import '../../domain/models/habit.dart';
import '../entities/completion_status.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_log_entity.dart';
import '../mapper/habit_mapper.dart';
import 'habit_local_datasource.dart';

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IsarService _isarService;
  final HabitMapper _mapper;

  HabitLocalDataSourceImpl(
    this._isarService,
    this._mapper,
  );

  Future<Isar> get _db => _isarService.database;

  @override
  Future<List<Habit>> getAll() async {
    final db = await _db;

    final entities = await db.habitEntitys.where().findAll();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final habits = <Habit>[];

    for (final entity in entities) {
      final completedToday = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(entity.uuid)
          .dateBetween(
            today,
            tomorrow,
            includeUpper: false,
          )
          .findFirst();

      final habit = _mapper.toDomain(entity).copyWith(
            completedToday: completedToday != null,
          );

      habits.add(habit);
    }

    return habits;
  }

  @override
  Future<Habit?> getById(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) {
      return null;
    }

    return _mapper.toDomain(entity);
  }

  @override
  Stream<List<Habit>> watchAll() async* {
    final db = await _db;

    yield* db.habitEntitys
        .where()
        .watch(fireImmediately: true)
        .asyncMap((entities) async {
      final now = DateTime.now();

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      final tomorrow = today.add(const Duration(days: 1));

      final habits = <Habit>[];

      for (final entity in entities) {
        final completedToday = await db.habitLogEntitys
            .filter()
            .habitIdEqualTo(entity.uuid)
            .dateBetween(
              today,
              tomorrow,
              includeUpper: false,
            )
            .findFirst();

        final habit = _mapper.toDomain(entity).copyWith(
              completedToday: completedToday != null,
            );

        habits.add(habit);
      }

      return habits;
    });
  }

  @override
  Future<void> save(Habit habit) async {
    final db = await _db;

    final entity = _mapper.toEntity(habit);

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    await db.writeTxn(() async {
      await db.habitEntitys.delete(entity.id);
    });
  }

  @override
  Future<void> archive(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    entity.archived = true;

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }

  @override
  Future<void> restore(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    entity.archived = false;

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }

  @override
  Future<void> completeHabit(
    String habitId, {
    int durationMinutes = 0,
    String notes = "",
  }) async {
    final db = await _db;

    final today = DateTime.now();
    final date = DateTime(today.year, today.month, today.day);

    // Find habit
    final habit =
        await db.habitEntitys.filter().uuidEqualTo(habitId).findFirst();

    if (habit == null) {
      throw Exception("Habit not found");
    }

    // Already completed today?
    final alreadyCompleted = await isCompletedToday(habitId);

    if (alreadyCompleted) {
      return;
    }

    await db.writeTxn(() async {
      final log = HabitLogEntity()
        ..habit.value = habit
        ..habitId = habit.uuid
        ..date = date
        ..status = CompletionStatus.completed
        ..completedAt = DateTime.now()
        ..durationMinutes = durationMinutes
        ..notes = notes
        ..xpEarned = 5;

      // Update Habit FIRST
      habit.currentStreak++;

      if (habit.currentStreak > habit.bestStreak) {
        habit.bestStreak = habit.currentStreak;
      }

      habit.totalCompleted++;
      habit.xp += log.xpEarned;
      habit.completedToday = true;
      habit.lastCompletedDate = DateTime.now();
      habit.updatedAt = DateTime.now();

      // Save Habit
      await db.habitEntitys.put(habit);

      // Save Link
      log.habit.value = habit;

      // Save Log
      await db.habitLogEntitys.put(log);

      await log.habit.save();

      final verify =
          await db.habitEntitys.filter().uuidEqualTo(habit.uuid).findFirst();

      debugPrint(
        "Saved -> completedToday=${verify?.completedToday}",
      );
    });
  }

  @override
  Future<bool> isCompletedToday(String habitId) async {
    final db = await _db;

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final tomorrow = today.add(const Duration(days: 1));

    final log = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .dateBetween(today, tomorrow, includeUpper: false)
        .findFirst();

    return log != null;
  }

  @override
  Future<void> uncompleteHabit(String habitId) async {
    debugPrint("Datasource Uncomplete");
    final db = await _db;

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final tomorrow = today.add(const Duration(days: 1));

    final habit =
        await db.habitEntitys.filter().uuidEqualTo(habitId).findFirst();

    if (habit == null) {
      throw Exception("Habit not found");
    }

    final log = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .dateBetween(
          today,
          tomorrow,
          includeUpper: false,
        )
        .findFirst();

    if (log == null) {
      return;
    }

    await db.writeTxn(() async {
      // Delete today's log
      await db.habitLogEntitys.delete(log.id);

      // Restore habit values
      if (habit.currentStreak > 0) {
        habit.currentStreak--;
      }

      if (habit.totalCompleted > 0) {
        habit.totalCompleted--;
      }

      if (habit.xp >= log.xpEarned) {
        habit.xp -= log.xpEarned;
      } else {
        habit.xp = 0;
      }

      habit.completedToday = false;
      habit.updatedAt = DateTime.now();

      await db.habitEntitys.put(habit);
    });
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogs() async {
    final db = await _db;

    final logs = await db.habitLogEntitys.where().sortByDateDesc().findAll();

    for (final log in logs) {
      await log.habit.load();
    }

    return logs;
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogsBetween(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _db;

    return db.habitLogEntitys
        .filter()
        .dateBetween(
          start,
          end,
          includeUpper: true,
        )
        .sortByDate()
        .findAll();
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogsForHabit(
    String habitId,
  ) async {
    final db = await _db;

    return db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .sortByDateDesc()
        .findAll();
  }

  @override
  Stream<List<HabitLogEntity>> watchHabitLogs() async* {
    final db = await _db;

    yield* db.habitLogEntitys
        .where()
        .watch(fireImmediately: true)
        .asyncMap((_) async {
      return db.habitLogEntitys.where().sortByDateDesc().findAll();
    });
  }
}
