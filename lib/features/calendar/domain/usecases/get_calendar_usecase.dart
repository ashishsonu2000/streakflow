import '../../../habits/domain/repositories/habit_repository.dart';
import '../models/calendar_view_model.dart';
import '../services/day_summary_builder.dart';

class GetCalendarUseCase {
  GetCalendarUseCase(
    this._repository, {
    DaySummaryBuilder? builder,
  }) : _builder = builder ?? const DaySummaryBuilder();

  final HabitRepository _repository;

  final DaySummaryBuilder _builder;

  Future<CalendarViewModel> call({
    required DateTime focusedMonth,
    required DateTime selectedDate,
  }) async {
    final habits = await _repository.getAll();

    final logs = await _repository.getHabitLogs();

    final days = _builder.build(
      focusedMonth: focusedMonth,
      selectedDate: selectedDate,
      habits: habits,
      logs: logs,
    );

    return CalendarViewModel(
      focusedMonth: DateTime(
        focusedMonth.year,
        focusedMonth.month,
      ),
      selectedDate: selectedDate,
      days: days,
      monthName: '',
    );
  }
}
