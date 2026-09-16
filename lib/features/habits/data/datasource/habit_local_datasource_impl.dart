import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:isar_community/isar.dart';
import 'package:streak_calculator_flutter/core/database/isar_service.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/calculators/streak_calculator.dart';
import '../../domain/enums/completion_status.dart';
import '../../domain/models/habit.dart';
import '../../domain/services/habit_schedule_service.dart';
import '../../domain/services/habit_statistics_rebuilder.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_log_entity.dart';
import '../mapper/habit_mapper.dart';
import 'habit_local_datasource.dart';

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  HabitLocalDataSourceImpl(
      this._isarService,
      this._mapper,
      );

  final IsarService _isarService;
  final HabitMapper _mapper;

  final HabitScheduleService _scheduleService =
  const HabitScheduleService();

  Future<Isar> get _db => _isarService.database;

  // ===========================================================
  // GET ALL
  // ===========================================================

  @override
  Future<List<Habit>> getAll() async {
    final db = await _db;

    final entities = await db.habitEntitys
        .where()
        .filter()
        .archivedEqualTo(false)
        .findAll();

    final selectedDate = AppDateUtils.today;
    final nextDate = selectedDate.add(
      const Duration(days: 1),
    );

    final habits = <Habit>[];

    for (final entity in entities) {
      final habit = _mapper.toDomain(entity);

      // Only show active habits that are scheduled
      // for the current/selected day.
      if (!_scheduleService.isScheduledForDate(
        habit,
        selectedDate,
      )) {
        continue;
      }

      final completedLog = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(entity.uuid)
          .dateBetween(
        selectedDate,
        nextDate,
        includeUpper: false,
      )
          .findFirst();

      habits.add(
        habit.copyWith(
          completedToday: completedLog != null &&
              completedLog.status ==
                  CompletionStatus.completed,
        ),
      );
    }

    return habits;
  }

  // ===========================================================
  // GET ALL FOR CALENDAR
  // ===========================================================

  @override
  Future<List<Habit>> getAllForCalendar() async {
    final db = await _db;

    final entities = await db.habitEntitys
        .where()
        .filter()
        .archivedEqualTo(false)
        .findAll();

    // Calendar needs ALL active habits.
    //
    // Do not filter by today's schedule because the
    // calendar determines the schedule for each individual date.

    return entities
        .map(
          (entity) => _mapper.toDomain(entity),
    )
        .toList();
  }

  // ===========================================================
  // GET BY ID
  // ===========================================================

  @override
  Future<Habit?> getById(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    if (entity == null) {
      return null;
    }

    final today = AppDateUtils.today;
    final tomorrow = today.add(
      const Duration(days: 1),
    );

    final completedLog = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(id)
        .dateBetween(
      today,
      tomorrow,
      includeUpper: false,
    )
        .findFirst();

    return _mapper.toDomain(entity).copyWith(
      completedToday: completedLog != null &&
          completedLog.status ==
              CompletionStatus.completed,
    );
  }

  // ===========================================================
  // WATCH
  // ===========================================================

  @override
  Stream<List<Habit>> watchAll() {
    return _watchByArchived(false);
  }

  @override
  Stream<List<Habit>> watchArchived() {
    return _watchByArchived(true);
  }

  // ===========================================================
  // SAVE
  // ===========================================================

  @override
  Future<void> save(Habit habit) async {
    final db = await _db;

    AppLogger.log(
      'Saving habit: ${habit.id} - ${habit.title}',
    );

    final existing = await db.habitEntitys
        .filter()
        .uuidEqualTo(habit.id)
        .findFirst();

    final entity = _mapper.toEntity(habit);

    if (existing != null) {
      entity.id = existing.id;
    }

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });

    final all = await db.habitEntitys
        .where()
        .findAll();

    AppLogger.log(
      'Habits in DB after save: ${all.length}',
    );
  }

  // ===========================================================
  // DELETE
  // ===========================================================

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    final habit = await db.habitEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    if (habit == null) {
      return;
    }

    final logs = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(id)
        .findAll();

    await db.writeTxn(() async {
      for (final log in logs) {
        await db.habitLogEntitys.delete(log.id);
      }

      await db.habitEntitys.delete(habit.id);
    });
  }

  // ===========================================================
  // ARCHIVE
  // ===========================================================

  @override
  Future<void> archive(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    if (entity == null) {
      return;
    }

    entity
      ..archived = true
      ..updatedAt = DateTime.now();

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });

    final archived = await db.habitEntitys
        .filter()
        .archivedEqualTo(true)
        .findAll();

    AppLogger.log(
      'Archived habits: ${archived.length}',
    );
  }

  // ===========================================================
  // RESTORE
  // ===========================================================

  @override
  Future<void> restore(String id) async {
    final db = await _db;

    final entity = await db.habitEntitys
        .filter()
        .uuidEqualTo(id)
        .findFirst();

    if (entity == null) {
      return;
    }

    entity
      ..archived = false
      ..updatedAt = DateTime.now();

    await db.writeTxn(() async {
      await db.habitEntitys.put(entity);
    });
  }

  // ===========================================================
  // COMPLETE HABIT
  // ===========================================================

  @override
  Future<void> completeHabit(
      String habitId, {
        DateTime? date,
        int durationMinutes = 0,
        String notes = '',
      }) async {
    final db = await _db;

    final selectedDate = date ?? DateTime.now();

    final day = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final nextDay = day.add(
      const Duration(days: 1),
    );

    // ---------------------------------------------------------
    // Load habit
    // ---------------------------------------------------------

    final habitEntity = await db.habitEntitys
        .filter()
        .uuidEqualTo(habitId)
        .findFirst();

    if (habitEntity == null) {
      throw Exception(
        'Habit not found.',
      );
    }

    final habit = _mapper.toDomain(habitEntity);

    // ---------------------------------------------------------
    // Schedule validation
    // ---------------------------------------------------------

    if (!_scheduleService.isScheduledForDate(
      habit,
      day,
    )) {
      throw Exception(
        'This habit is not scheduled for this date.',
      );
    }

    // ---------------------------------------------------------
    // Find completion for this occurrence
    // ---------------------------------------------------------

    final existingLog = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .dateBetween(
      day,
      nextDay,
      includeUpper: false,
    )
        .findFirst();

    // ---------------------------------------------------------
    // Already completed
    // ---------------------------------------------------------

    if (existingLog != null &&
        existingLog.status ==
            CompletionStatus.completed) {
      return;
    }

    // ---------------------------------------------------------
    // Create / restore log
    // ---------------------------------------------------------

    final log = existingLog ?? HabitLogEntity();

    log
      ..habitId = habitId
      ..date = day
      ..status = CompletionStatus.completed
      ..completedAt = DateTime.now()
      ..durationMinutes = durationMinutes
      ..notes = notes
      ..xpEarned = habit.xpReward;

    // ---------------------------------------------------------
    // Save + rebuild statistics
    // ---------------------------------------------------------

    await db.writeTxn(() async {
      await db.habitLogEntitys.put(log);

      final logs = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(habitId)
          .findAll();

      final completedLogs = logs
          .where(
            (item) =>
        item.status ==
            CompletionStatus.completed,
      )
          .toList();

      // -------------------------------------------------------
      // Streak
      // -------------------------------------------------------

      final streak = StreakCalculator.calculate(
        completedLogs,
        habit: habit,
      );

      habitEntity.currentStreak =
          streak.currentStreak;

      habitEntity.bestStreak =
          streak.longestStreak;

      habitEntity.totalCompleted =
          completedLogs.length;

      // -------------------------------------------------------
      // XP
      // -------------------------------------------------------

      habitEntity.xp =
          completedLogs.fold<int>(
            0,
                (total, item) =>
            total + item.xpEarned,
          );

      // -------------------------------------------------------
      // Today's completion cache
      // -------------------------------------------------------

      final today = AppDateUtils.today;

      final tomorrow = today.add(
        const Duration(days: 1),
      );

      final todayLog = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(habitId)
          .dateBetween(
        today,
        tomorrow,
        includeUpper: false,
      )
          .findFirst();

      habitEntity.completedToday =
          todayLog != null &&
              todayLog.status ==
                  CompletionStatus.completed;

      // -------------------------------------------------------
      // Latest completion
      // -------------------------------------------------------

      completedLogs.sort(
            (a, b) => b.date.compareTo(a.date),
      );

      habitEntity.lastCompletedDate =
      completedLogs.isEmpty
          ? null
          : completedLogs.first.completedAt;

      habitEntity.updatedAt = DateTime.now();

      await db.habitEntitys.put(
        habitEntity,
      );
    });

    AppLogger.log(
      'Habit completed: '
          '$habitId / '
          '${day.toIso8601String()}',
    );
  }

  // ===========================================================
  // UNCOMPLETE / UNDO
  // ===========================================================

  @override
  Future<void> uncompleteHabit(
      String habitId, {
        DateTime? date,
      }) async {
    AppLogger.log(
      '========== UNDO HABIT ==========',
    );

    final db = await _db;

    final selectedDate = date ?? DateTime.now();

    final day = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final nextDay = day.add(
      const Duration(days: 1),
    );

    // ---------------------------------------------------------
    // Load habit
    // ---------------------------------------------------------

    final habit = await db.habitEntitys
        .filter()
        .uuidEqualTo(habitId)
        .findFirst();

    if (habit == null) {
      throw Exception(
        'Habit not found.',
      );
    }

    // ---------------------------------------------------------
    // Find selected occurrence
    // ---------------------------------------------------------

    final log = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .dateBetween(
      day,
      nextDay,
      includeUpper: false,
    )
        .findFirst();

    if (log == null) {
      AppLogger.log(
        'Undo: no log found for '
            '$habitId / $day',
      );
      return;
    }

    // ---------------------------------------------------------
    // Delete selected occurrence
    // ---------------------------------------------------------

    await db.writeTxn(() async {
      await db.habitLogEntitys.delete(
        log.id,
      );

      // -------------------------------------------------------
      // Reload remaining logs
      // -------------------------------------------------------

      final logs = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(habitId)
          .findAll();

      final completedLogs = logs
          .where(
            (item) =>
        item.status ==
            CompletionStatus.completed,
      )
          .toList();

      // -------------------------------------------------------
      // Recalculate streak
      // -------------------------------------------------------

      final streak = StreakCalculator.calculate(
        completedLogs,
        habit: _mapper.toDomain(habit),
      );

      habit.currentStreak =
          streak.currentStreak;

      habit.bestStreak =
          streak.longestStreak;

      habit.totalCompleted =
          completedLogs.length;

      // -------------------------------------------------------
      // Recalculate XP
      // -------------------------------------------------------

      habit.xp =
          completedLogs.fold<int>(
            0,
                (total, item) =>
            total + item.xpEarned,
          );

      // -------------------------------------------------------
      // Recalculate today's state
      // -------------------------------------------------------

      final today = AppDateUtils.today;

      final tomorrow = today.add(
        const Duration(days: 1),
      );

      final todayLog = await db.habitLogEntitys
          .filter()
          .habitIdEqualTo(habitId)
          .dateBetween(
        today,
        tomorrow,
        includeUpper: false,
      )
          .findFirst();

      habit.completedToday =
          todayLog != null &&
              todayLog.status ==
                  CompletionStatus.completed;

      // -------------------------------------------------------
      // Latest completion
      // -------------------------------------------------------

      completedLogs.sort(
            (a, b) => b.date.compareTo(a.date),
      );

      habit.lastCompletedDate =
      completedLogs.isEmpty
          ? null
          : completedLogs.first.completedAt;

      habit.updatedAt = DateTime.now();

      await db.habitEntitys.put(
        habit,
      );
    });

    AppLogger.log(
      'UNDO SUCCESS: '
          '$habitId / '
          '${day.toIso8601String()}',
    );
  }

  // ===========================================================
  // IS COMPLETED TODAY
  // ===========================================================

  @override
  Future<bool> isCompletedToday(String habitId) async {
    final db = await _db;

    final today = AppDateUtils.today;
    final tomorrow = AppDateUtils.tomorrow;

    final log = await db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .dateBetween(
      today,
      tomorrow,
      includeUpper: false,
    )
        .findFirst();

    return log != null &&
        log.status ==
            CompletionStatus.completed;
  }

  // ===========================================================
  // GET ALL LOGS
  // ===========================================================

  @override
  Future<List<HabitLogEntity>> getHabitLogs() async {
    final db = await _db;

    final logs = await db.habitLogEntitys
        .where()
        .sortByDateDesc()
        .findAll();

    for (final log in logs) {
      await log.habit.load();
    }

    return logs;
  }

  // ===========================================================
  // GET LOGS BETWEEN DATES
  // ===========================================================

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

  // ===========================================================
  // WATCH ALL LOGS
  // ===========================================================

  @override
  Stream<List<HabitLogEntity>> watchHabitLogs() async* {
    final db = await _db;

    yield* db.habitLogEntitys
        .where()
        .watch(
      fireImmediately: true,
    )
        .asyncMap(
          (_) async {
        return db.habitLogEntitys
            .where()
            .sortByDateDesc()
            .findAll();
      },
    );
  }

  // ===========================================================
  // WATCH HABITS
  // ===========================================================

  Stream<List<Habit>> _watchByArchived(
      bool archived,
      ) async* {
    final db = await _db;

    yield* db.habitEntitys
        .filter()
        .archivedEqualTo(archived)
        .watch(
      fireImmediately: true,
    )
        .asyncMap(
          (entities) async {
        final today = AppDateUtils.today;
        final tomorrow = AppDateUtils.tomorrow;

        // -------------------------------------------------
        // Load today's logs once.
        //
        // Only active habits need completedToday for the
        // normal Home/Dashboard list.
        // -------------------------------------------------

        final todayLogs = archived
            ? const <HabitLogEntity>[]
            : await db.habitLogEntitys
            .filter()
            .dateBetween(
          today,
          tomorrow,
          includeUpper: false,
        )
            .findAll();

        final completedHabitIds = todayLogs
            .where(
              (log) =>
          log.status ==
              CompletionStatus.completed,
        )
            .map(
              (log) => log.habitId,
        )
            .toSet();

        // -------------------------------------------------
        // Build habits
        // -------------------------------------------------

        final habits = <Habit>[];

        for (final entity in entities) {
          final habit = _mapper.toDomain(entity);

          // IMPORTANT:
          //
          // Active habits:
          // Only return habits scheduled for today.
          //
          // Archived habits:
          // NEVER apply today's schedule filter.
          // Archived page must show every archived habit.
          if (!archived &&
              !_scheduleService.isScheduledForDate(
                habit,
                today,
              )) {
            continue;
          }

          final completedToday =
              !archived &&
                  completedHabitIds.contains(
                    entity.uuid,
                  );

          habits.add(
            habit.copyWith(
              completedToday: completedToday,
            ),
          );
        }

        // -------------------------------------------------
        // Debug
        // -------------------------------------------------

        AppLogger.log(
          '===== WATCH ${archived ? 'ARCHIVED' : 'ACTIVE'} HABITS =====',
        );

        for (final habit in habits) {
          AppLogger.log(
            '${habit.title} -> '
                'archived=${habit.archived}, '
                'completedToday=${habit.completedToday}, '
                'current=${habit.currentStreak}, '
                'best=${habit.bestStreak}',
          );
        }

        return habits;
      },
    );
  }

  // ===========================================================
  // REBUILD STATISTICS
  // ===========================================================

  @override
  Future<void> rebuildHabitStatistics() async {
    final db = await _db;

    await const HabitStatisticsRebuilder().rebuild(db);
  }

  // ===========================================================
  // GET LOGS FOR HABIT
  // ===========================================================

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

  // ===========================================================
  // WATCH LOGS FOR HABIT
  // ===========================================================

  @override
  Stream<List<HabitLogEntity>> watchHabitLogsForHabit(
      String habitId,
      ) async* {
    final db = await _db;

    yield* db.habitLogEntitys
        .filter()
        .habitIdEqualTo(habitId)
        .watch(
      fireImmediately: true,
    );
  }

  // ===========================================================
  // WATCH HABIT BY ID
  // ===========================================================

  @override
  Stream<Habit?> watchById(
      String id,
      ) async* {
    final db = await _db;

    yield* db.habitEntitys
        .filter()
        .uuidEqualTo(id)
        .watch(
      fireImmediately: true,
    )
        .asyncMap(
          (entities) async {
        if (entities.isEmpty) {
          return null;
        }

        final entity = entities.first;

        final today = AppDateUtils.today;
        final tomorrow = AppDateUtils.tomorrow;

        final completedLog =
        await db.habitLogEntitys
            .filter()
            .habitIdEqualTo(entity.uuid)
            .dateBetween(
          today,
          tomorrow,
          includeUpper: false,
        )
            .findFirst();

        return _mapper.toDomain(entity).copyWith(
          completedToday:
          completedLog != null &&
              completedLog.status ==
                  CompletionStatus.completed,
        );
      },
    );
  }

  // ===========================================================
  // CLEAR DATABASE
  // ===========================================================

  @override
  Future<void> clearDatabase() async {
    final db = await _db;

    await db.writeTxn(
          () async {
        await db.habitLogEntitys.clear();
        await db.habitEntitys.clear();
      },
    );

    AppLogger.log(
      '========================================',
    );

    AppLogger.log(
      'Database cleared successfully.',
    );

    AppLogger.log(
      '========================================',
    );
  }
}