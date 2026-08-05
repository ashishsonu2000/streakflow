import 'package:flutter/material.dart';

import '../../../calendar/domain/usecases/get_calendar_usecase.dart';
import '../../../statistics/domain/usecases/get_statistics_usecase.dart';

import '../builders/dashboard_mapper.dart';
import '../models/dashboard_view_model.dart';

class GetDashboardUseCase {
  GetDashboardUseCase(
    this._getStatisticsUseCase,
    this._dashboardMapper,
    this._calendarUseCase,
  );
  final GetCalendarUseCase _calendarUseCase;
  final GetStatisticsUseCase _getStatisticsUseCase;
  final DashboardMapper _dashboardMapper;

  Future<DashboardViewModel> call() async {
    debugPrint('===== DASHBOARD =====');

    //------------------------------------------
    // Statistics
    //------------------------------------------

    final statistics = await _getStatisticsUseCase();

    //------------------------------------------
    // Dashboard
    //------------------------------------------
    final calendar = await _calendarUseCase(
      focusedMonth: DateTime.now(),
      selectedDate: DateTime.now(),
    );
    return _dashboardMapper.map(
      statistics,
      calendar: calendar,
      userName: 'Ashish',
    );
  }
}
