import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../models/calendar_day_view_model.dart';
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
    final normalizedMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month,
    );

    late final List<Habit> loadedHabits;
    late final List<HabitLogEntity> loadedLogs;

    if (habits != null && logs != null) {
      loadedHabits = habits;
      loadedLogs = logs;
    } else {
      final results = await Future.wait([
        habits != null ? Future.value(habits) : _repository.getAll(),
        logs != null ? Future.value(logs) : _repository.getHabitLogs(),
      ]);

      loadedHabits = results[0] as List<Habit>;
      loadedLogs = results[1] as List<HabitLogEntity>;
    }

    final days = _builder.build(
      focusedMonth: normalizedMonth,
      selectedDate: selectedDate,
      habits: loadedHabits,
      logs: loadedLogs,
    );

    CalendarDayViewModel? selectedDay;

    for (final day in days) {
      if (day.isSelected) {
        selectedDay = day;
        break;
      }
    }

    return CalendarViewModel(
      focusedMonth: normalizedMonth,
      selectedDate: selectedDate,
      days: days,
      selectedDay: selectedDay,
      monthName: _monthName(normalizedMonth),
    );
  }

  String _monthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}
