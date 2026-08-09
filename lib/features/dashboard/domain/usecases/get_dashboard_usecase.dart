import 'package:flutter/material.dart';

import '../../../calendar/domain/usecases/get_calendar_usecase.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/usecases/get_habits_usecase.dart';
import '../../../statistics/domain/usecases/get_statistics_usecase.dart';

import '../builders/dashboard_mapper.dart';
import '../models/dashboard_view_model.dart';

class GetDashboardUseCase {
  GetDashboardUseCase(
      this._getStatisticsUseCase,
      this._dashboardMapper,
      this._calendarUseCase,
      this._habitRepository,
      );

  final GetStatisticsUseCase _getStatisticsUseCase;
  final DashboardMapper _dashboardMapper;
  final GetCalendarUseCase _calendarUseCase;
  final HabitRepository _habitRepository;

  Future<DashboardViewModel> call() async {
    debugPrint('===== DASHBOARD =====');

    final statistics = await _getStatisticsUseCase();

    final habits = await _habitRepository.getAll();

    final logs = await _habitRepository.getLogs();

    final calendar = await _calendarUseCase(
      focusedMonth: DateTime.now(),
      selectedDate: DateTime.now(),
    );

    return _dashboardMapper.map(
      statistics,
      habits: habits,
      logs: logs,
      calendar: calendar,
      userName: 'Ashish',
    );
  }
}
