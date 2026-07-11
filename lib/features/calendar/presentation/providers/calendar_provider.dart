import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/models/calendar_state.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/services/calendar_builder.dart';

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier(
    this._repository,
  ) : super(
          CalendarState(
            focusedMonth: DateTime.now(),
            selectedDate: DateTime.now(),
          ),
        ) {
    loadMonth();
  }

  final CalendarRepository _repository;

  Future<void> loadMonth() async {
    state = state.copyWith(
      isLoading: true,
    );

    final days = await _repository.getMonth(
      state.focusedMonth,
      state.selectedDate,
    );

    state = state.copyWith(
      days: days,
      isLoading: false,
    );
  }

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(
      selectedDate: date,
    );

    await loadMonth();
  }

  Future<void> nextMonth() async {
    state = state.copyWith(
      focusedMonth: DateTime(
        state.focusedMonth.year,
        state.focusedMonth.month + 1,
      ),
    );

    await loadMonth();
  }

  Future<void> previousMonth() async {
    state = state.copyWith(
      focusedMonth: DateTime(
        state.focusedMonth.year,
        state.focusedMonth.month - 1,
      ),
    );

    await loadMonth();
  }

  Future<void> jumpToToday() async {
    final today = DateTime.now();

    state = state.copyWith(
      focusedMonth: DateTime(
        today.year,
        today.month,
      ),
      selectedDate: today,
    );

    await loadMonth();
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) {
    return CalendarNotifier(
      ref.read(calendarRepositoryProvider),
    );
  },
);

final calendarRepositoryProvider = Provider<CalendarRepository>(
  (ref) {
    return CalendarRepositoryImpl(
      ref.read(habitRepositoryProvider),
      const CalendarBuilder(),
    );
  },
);
