import '../../../habits/domain/repositories/habit_repository.dart';

import '../../domain/models/calendar_day_state.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/services/calendar_builder.dart';
import '../../utils/calendar_utils.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl(
    this._habitRepository,
    this._builder,
  );

  final HabitRepository _habitRepository;

  final CalendarBuilder _builder;

  @override
  Future<List<CalendarDayState>> getMonth(
    DateTime month,
    DateTime selectedDate,
  ) async {
    final habits = await _habitRepository.getAll();
    final logs = await _habitRepository.getHabitLogs();

    final dates = CalendarUtils.visibleDates(month);

    return _builder.build(
      dates: dates,
      logs: logs,
      totalHabits: habits.length,
      selectedDate: selectedDate,
    );
  }
}
