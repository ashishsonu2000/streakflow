import 'calendar_day_state.dart';

class CalendarState {
  const CalendarState({
    required this.focusedMonth,
    required this.selectedDate,
    this.days = const [],
    this.isLoading = false,
  });

  final DateTime focusedMonth;

  final DateTime selectedDate;

  final List<CalendarDayState> days;

  final bool isLoading;

  CalendarState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<CalendarDayState>? days,
    bool? isLoading,
  }) {
    return CalendarState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      days: days ?? this.days,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
