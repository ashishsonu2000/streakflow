import 'calendar_day_view_model.dart';

class CalendarViewModel {
  const CalendarViewModel({
    required this.focusedMonth,
    required this.selectedDate,
    required this.days,
    required this.monthName,
    this.selectedDay,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final List<CalendarDayViewModel> days;
  final String monthName;
  final CalendarDayViewModel? selectedDay;

  CalendarViewModel copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<CalendarDayViewModel>? days,
    String? monthName,
    CalendarDayViewModel? selectedDay,
  }) {
    return CalendarViewModel(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      days: days ?? this.days,
      monthName: monthName ?? this.monthName,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}
