import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/database/isar_service.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/calculators/streak_calculator.dart';
import '../../domain/models/habit.dart';
import '../../domain/enums/completion_status.dart';
import '../../domain/services/habit_statistics_rebuilder.dart';
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

    final entities =
        await db.habitEntitys.where().filter().archivedEqualTo(false).findAll();

    final today = AppDateUtils.today;
    final tomorrow = AppDateUtils.tomorrow;

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
  Stream<List<Habit>> watchAll() {
    return _watchByArchived(false);
  }

  @override
  Stream<List<Habit>> watchArchived() {
    return _watchByArchived(true);
  }

  @override
  Future<void> save(Habit habit) async {
    final db = await _db;

    debugPrint('Saving habit: ${habit.id} - ${habit.title}');

    final existing =
        await db.habitEntitys.filter().uuidEqualTo(habit.id).findFirst();

    final entity = _mapper.toEntity(habit);

    if (existing != null) {
      entity.id = existing.id;
    }

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });

    final all = await db.habitEntitys.where().findAll();
    debugPrint('Habits in DB after save: ${all.length}');
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    final habit = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (habit == null) {
      return;
    }

    final logs = await db.habitLogEntitys.filter().habitIdEqualTo(id).findAll();

    await db.writeTxn(() async {
      // Delete all logs first.
      for (final log in logs) {
        await db.habitLogEntitys.delete(log.id);
      }

      // Delete habit.
      await db.habitEntitys.delete(habit.id);
    });
  }

  @override
  Future<void> archive(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;

    entity.archived = true;
    entity.updatedAt = DateTime.now();

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });

    final archived =
        await db.habitEntitys.filter().archivedEqualTo(true).findAll();

    debugPrint('Archived habits: ${archived.length}');
  }

  @override
  Future<void> restore(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys.filter().uuidEqualTo(id).findFirst();

    if (entity == null) return;
    entity
      ..archived = true
      ..updatedAt = DateTime.now();

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
    debugPrint("========================================");
    debugPrint("DATASOURCE: completeHabit()");
    debugPrint("Habit ID: $habitId");
    debugPrint("========================================");

    final db = await _db;

    final today = DateTime.now();
    final date = DateTime(today.year, today.month, today.day);

    debugPrint("Loading habit...");

    final habit =
        await db.habitEntitys.filter().uuidEqualTo(habitId).findFirst();

    if (habit == null) {
      debugPrint("ERROR: Habit not found");
      throw Exception("Habit not found");
    }

    debugPrint("Habit found: ${habit.title}");

    final alreadyCompleted = await isCompletedToday(habitId);

    debugPrint("Already completed today: $alreadyCompleted");

    if (alreadyCompleted) {
      debugPrint("Skipping completion because today's log already exists.");
      return;
    }

    await db.writeTxn(() async {
      debugPrint("Creating HabitLog...");

      final log = HabitLogEntity()
        ..habit.value = habit
        ..habitId = habit.uuid
        ..date = date
        ..status = CompletionStatus.completed
        ..completedAt = DateTime.now()
        ..durationMinutes = durationMinutes
        ..notes = notes
        ..xpEarned = 5;

      await db.habitLogEntitys.put(log);
      await log.habit.save();

      debugPrint("HabitLog saved successfully.");

      final logs = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(habit.uuid)
          .findAll();

      debugPrint("Total logs for habit: ${logs.length}");

      final streak = StreakCalculator.calculate(logs);

      debugPrint(
        "Calculated streak -> "
        "Current=${streak.currentStreak}, "
        "Best=${streak.longestStreak}",
      );

      habit.currentStreak = streak.currentStreak;
      habit.bestStreak = streak.longestStreak;
      habit.totalCompleted++;
      habit.xp += log.xpEarned;
      habit.completedToday = true;
      habit.lastCompletedDate = DateTime.now();
      habit.updatedAt = DateTime.now();

      debugPrint("Saving updated habit...");
      debugPrint(
        'Habit BEFORE save -> '
        'Current=${habit.currentStreak}, '
        'Best=${habit.bestStreak}',
      );
      await db.habitEntitys.put(habit);

      final verify =
          await db.habitEntitys.filter().uuidEqualTo(habit.uuid).findFirst();
      debugPrint(
        'Habit AFTER save -> '
        'Current=${verify?.currentStreak}, '
        'Best=${verify?.bestStreak}',
      );
      debugPrint("========================================");
      debugPrint("Habit saved successfully");
      debugPrint("Title           : ${verify?.title}");
      debugPrint("completedToday  : ${verify?.completedToday}");
      debugPrint("currentStreak   : ${verify?.currentStreak}");
      debugPrint("bestStreak      : ${verify?.bestStreak}");
      debugPrint("totalCompleted  : ${verify?.totalCompleted}");
      debugPrint("xp              : ${verify?.xp}");
      debugPrint("========================================");
    });

    debugPrint("completeHabit() finished successfully.");
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
      // Delete today's completion
      await db.habitLogEntitys.delete(log.id);

      // Reload remaining logs
      final logs = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(habit.uuid)
          .findAll();

      final streak = StreakCalculator.calculate(logs);

      habit.currentStreak = streak.currentStreak;
      habit.bestStreak = streak.longestStreak;
      habit.totalCompleted = streak.completedDays;

      habit.xp = (habit.xp - log.xpEarned).clamp(0, 1 << 31);

      habit.completedToday = false;
      habit.updatedAt = DateTime.now();

      final lastLog = logs.isEmpty
          ? null
          : (logs..sort((a, b) => b.date.compareTo(a.date))).first;

      habit.lastCompletedDate = lastLog?.completedAt;

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
        .dateBetween(start, end)
        .sortByDate()
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

  Stream<List<Habit>> _watchByArchived(bool archived) async* {
    final db = await _db;

    yield* db.habitEntitys
        .filter()
        .archivedEqualTo(archived)
        .watch(fireImmediately: true)
        .map((entities) {
      debugPrint('===== WATCH ALL =====');

      for (final e in entities) {
        debugPrint(
          '${e.title} -> current=${e.currentStreak}, best=${e.bestStreak}',
        );
      }

      return entities.map(_mapper.toDomain).toList();
    });
  }

  @override
  Future<void> rebuildHabitStatistics() async {
    final db = await _db;

    const HabitStatisticsRebuilder().rebuild(db);
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
  Stream<List<HabitLogEntity>> watchHabitLogsForHabit(
    String habitId,
  ) async* {
    final db = await _db;

    yield* db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .watch(fireImmediately: true);
  }
}
