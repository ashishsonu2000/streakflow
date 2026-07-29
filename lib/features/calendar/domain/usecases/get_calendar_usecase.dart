import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';
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
    List<Habit>? habits,
    List<HabitLogEntity>? logs,
  }) async {
    final loadedHabits = habits ?? await _repository.getAll();

    final loadedLogs = logs ?? await _repository.getHabitLogs();

    final days = _builder.build(
      focusedMonth: focusedMonth,
      selectedDate: selectedDate,
      habits: loadedHabits,
      logs: loadedLogs,
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
