import 'package:flutter/material.dart';

import '../../../calendar/domain/usecases/get_calendar_usecase.dart';
import '../../../habits/domain/usecases/get_habits_usecase.dart';
import '../../../statistics/domain/usecases/get_statistics_usecase.dart';

import '../builders/dashboard_mapper.dart';
import '../models/dashboard_view_model.dart';

class GetDashboardUseCase {
  GetDashboardUseCase(
    this._getStatisticsUseCase,
    this._getHabitsUseCase,
    this._dashboardMapper,
    this._calendarUseCase,
  );

  final GetStatisticsUseCase _getStatisticsUseCase;
  final GetHabitsUseCase _getHabitsUseCase;
  final DashboardMapper _dashboardMapper;
  final GetCalendarUseCase _calendarUseCase;

  Future<DashboardViewModel> call() async {
    debugPrint('===== DASHBOARD =====');

    final statistics = await _getStatisticsUseCase();

    final habits = await _getHabitsUseCase();

    final calendar = await _calendarUseCase(
      focusedMonth: DateTime.now(),
      selectedDate: DateTime.now(),
    );

    return _dashboardMapper.map(
      statistics,
      habits: habits,
      calendar: calendar,
      userName: 'Ashish',
    );
  }
}
