import '../models/calendar_month.dart';

abstract interface class CalendarRepository {
  Future<CalendarMonth> getMonth(
    int year,
    int month,
  );
}
