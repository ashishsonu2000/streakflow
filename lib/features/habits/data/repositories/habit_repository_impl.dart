import 'package:flutter/material.dart';

import '../../domain/mappers/habit_log_mapper.dart';
import '../../domain/models/habit_log.dart';
import '../datasource/habit_local_datasource.dart';
import '../entities/habit_log_entity.dart';
import '../../domain/models/habit.dart';
import '../../domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(
    this._localDataSource,
    //this._analytics,
  );
  final HabitLogMapper _habitLogMapper = const HabitLogMapper();
  final HabitLocalDataSource _localDataSource;

  //final HabitAnalyticsService _analytics;

  @override
  Future<List<Habit>> getAll() {
    return _localDataSource.getAll();
  }

  @override
  Future<List<Habit>> getAllForCalendar() {
    return _localDataSource.getAllForCalendar();
  }

  @override
  Stream<List<Habit>> watchAll() {
    return _localDataSource.watchAll();
  }

  @override
  Future<Habit?> getById(String id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<void> save(Habit habit) {
    return _localDataSource.save(habit);
  }

  @override
  Future<void> delete(String id) {
    return _localDataSource.delete(id);
  }

  @override
  Future<void> archive(String id) {
    return _localDataSource.archive(id);
  }

  @override
  Future<void> restore(String id) {
    return _localDataSource.restore(id);
  }

  @override
  Future<void> completeHabit(
      String habitId, {
        DateTime? date,
        int durationMinutes = 0,
        String notes = '',
      }) {
    return _localDataSource.completeHabit(
      habitId,
      date: date,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }

  @override
  Future<void> uncompleteHabit(
      String habitId, {
        DateTime? date,
      }) {
    return _localDataSource.uncompleteHabit(
      habitId,
      date: date,
    );
  }

  @override
  Future<bool> isCompletedToday(String habitId) {
    return _localDataSource.isCompletedToday(habitId);
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogs() {
    return _localDataSource.getHabitLogs();
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogsForHabit(String habitId) {
    return _localDataSource.getHabitLogsForHabit(habitId);
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogsBetween(
    DateTime start,
    DateTime end,
  ) {
    return _localDataSource.getHabitLogsBetween(start, end);
  }

  @override
  Stream<List<HabitLogEntity>> watchHabitLogs() {
    return _localDataSource.watchHabitLogs();
  }

  @override
  Future<void> update(Habit habit) async {
    await _localDataSource.save(habit);
  }

  @override
  Stream<List<Habit>> watchArchived() {
    return _localDataSource.watchArchived();
  }

  @override
  Future<void> rebuildHabitStatistics() {
    return _localDataSource.rebuildHabitStatistics();
  }

  @override
  Future<List<HabitLog>> getLogs() async {
    final logs = await _localDataSource.getHabitLogs();

    return logs.map(_habitLogMapper.toDomain).toList();
  }

  @override
  Future<List<HabitLog>> getLogsForHabit(
    String habitId,
  ) async {
    final logs = await _localDataSource.getHabitLogsForHabit(habitId);

    return logs.map(_habitLogMapper.toDomain).toList();
  }

  @override
  Future<List<HabitLog>> getLogsBetween(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await _localDataSource.getHabitLogsBetween(
      start,
      end,
    );

    return logs.map(_habitLogMapper.toDomain).toList();
  }

  @override
  Stream<List<HabitLog>> watchLogs() {
    return _localDataSource.watchHabitLogs().map(
          (logs) => logs.map(_habitLogMapper.toDomain).toList(),
        );
  }

  @override
  Future<List<HabitLogEntity>> getHabitLogsForDate(
    DateTime date,
  ) async {
    final start = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final end = start.add(
      const Duration(days: 1),
    );

    final logs = await getHabitLogs();

    return logs.where((log) {
      return !log.date.isBefore(start) && log.date.isBefore(end);
    }).toList();
  }

  @override
  Stream<List<HabitLog>> watchLogsForHabit(
      String habitId,
      ) {
    return _localDataSource
        .watchHabitLogsForHabit(
      habitId,
    )
        .map(
          (logs) => logs
        ..sort(
              (a, b) => b.date.compareTo(
            a.date,
          ),
        ),
    )
        .map(
          (logs) => logs
          .map(
        _habitLogMapper.toDomain,
      )
          .toList(),
    );
  }

  @override
  Stream<Habit?> watchById(
      String id,
      ) {
    return _localDataSource.watchById(
      id,
    );
  }

  @override
  Future<void> clearDatabase() {
    return _localDataSource.clearDatabase();
  }
}
