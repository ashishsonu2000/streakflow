import 'package:flutter/material.dart';

import '../../../calendar/domain/usecases/get_calendar_usecase.dart';
import '../../../habits/domain/repositories/habit_repository.dart';

import '../builders/dashboard_summary_builder.dart';
import '../models/dashboard_view_model.dart';

class GetDashboardUseCase {
  GetDashboardUseCase(
    this._habitRepository,
    this._calendarUseCase,
    this._builder,
  );

  final HabitRepository _habitRepository;
  final GetCalendarUseCase _calendarUseCase;
  final DashboardSummaryBuilder _builder;

  Future<DashboardViewModel> call() async {
    //------------------------------------------
    // Habits
    //------------------------------------------

    final habits = await _habitRepository.getAll();

    //------------------------------------------
    // Habit Logs
    //------------------------------------------

    final logs = await _habitRepository.getHabitLogs();

    debugPrint('===== DASHBOARD =====');
    debugPrint('Habits: ${habits.length}');
    debugPrint('Logs: ${logs.length}');

    //------------------------------------------
    // Calendar
    //------------------------------------------

    final calendar = await _calendarUseCase(
      focusedMonth: DateTime.now(),
      selectedDate: DateTime.now(),
    );

    //------------------------------------------
    // Dashboard
    //------------------------------------------

    return _builder.build(
      userName: 'Ashish',
      habits: habits,
      logs: logs,
      calendar: calendar,
    );
  }
}
