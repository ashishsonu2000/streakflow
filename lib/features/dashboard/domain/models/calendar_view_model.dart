import '../../../habits/data/entities/habit_log_entity.dart';
import 'calendar_day_view_model.dart';

class CalendarViewModel {
  const CalendarViewModel({
    required this.focusedMonth,
    required this.selectedDate,
    required this.days,
    this.isLoading = false,
  });

  /// Currently visible month
  final DateTime focusedMonth;

  /// Selected date
  final DateTime selectedDate;

  /// 42 visible calendar cells
  final List<CalendarDayViewModel> days;

  final bool isLoading;

  CalendarViewModel copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<CalendarDayViewModel>? days,
    bool? isLoading,
  }) {
    return CalendarViewModel(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      days: days ?? this.days,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
