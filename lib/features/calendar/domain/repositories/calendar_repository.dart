import '../models/calendar_day_state.dart';

abstract class CalendarRepository {
  Future<List<CalendarDayState>> getMonth(
    DateTime month,
    DateTime selectedDate,
  );
}
