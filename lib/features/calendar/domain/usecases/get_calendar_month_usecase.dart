import '../models/calendar_month.dart';
import '../repositories/calendar_repository.dart';

class GetCalendarMonthUseCase {
  const GetCalendarMonthUseCase(
    this._repository,
  );

  final CalendarRepository _repository;

  Future<CalendarMonth> call(
    DateTime month,
  ) {
    return _repository.loadMonth(month);
  }
}
