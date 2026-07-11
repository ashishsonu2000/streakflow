import 'package:flutter/material.dart';

import '../../data/datasource/habit_local_datasource.dart';
import '../../data/entities/habit_log_entity.dart';
import '../../domain/models/habit.dart';
import '../../domain/repositories/habit_repository.dart';

import '../models/analytics_summary.dart';

import '../services/habit_analytics_service.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(
    this._localDataSource,
    this._analytics,
  );

  final HabitLocalDataSource _localDataSource;

  final HabitAnalyticsService _analytics;

  @override
  Future<List<Habit>> getAll() {
    return _localDataSource.getAll();
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
    int durationMinutes = 0,
    String notes = "",
  }) {
    return _localDataSource.completeHabit(
      habitId,
      durationMinutes: durationMinutes,
      notes: notes,
    );
  }

  @override
  Future<void> uncompleteHabit(String habitId) {
    debugPrint("Repository Uncomplete");
    return _localDataSource.uncompleteHabit(habitId);
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
  Future<AnalyticsSummary> getAnalytics(
    String habitId,
  ) async {
    final habit = await _localDataSource.getById(
      habitId,
    );

    if (habit == null) {
      throw Exception(
        "Habit not found",
      );
    }

    final logs = await _localDataSource.getHabitLogsForHabit(
      habitId,
    );

    return _analytics.build(
      habit,
      logs,
    );
  }
}
