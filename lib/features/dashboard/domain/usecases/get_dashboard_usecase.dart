import '../../../calendar/domain/usecases/get_calendar_usecase.dart';
import '../../../habits/domain/repositories/habit_repository.dart';

import '../builders/dashboard_builder.dart';
import '../models/dashboard_view_model.dart';

class GetDashboardUseCase {
  GetDashboardUseCase(
    this._habitRepository,
    this._calendarUseCase, {
    DashboardBuilder? builder,
  }) : _builder = builder ?? const DashboardBuilder();

  final HabitRepository _habitRepository;
  final GetCalendarUseCase _calendarUseCase;
  final DashboardBuilder _builder;

  Future<DashboardViewModel> call() async {
    //------------------------------------------
    // Load Habits
    //------------------------------------------
    final habits = await _habitRepository.getAll();

    //------------------------------------------
    // Calendar
    //------------------------------------------
    final calendar = await _calendarUseCase(
      focusedMonth: DateTime.now(),
      selectedDate: DateTime.now(),
    );

    //------------------------------------------
    // Build Dashboard
    //------------------------------------------
    return _builder.build(
      userName: "Ashish",
      habits: habits,
      calendar: calendar,
    );
  }
}
