import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/models/calendar_view_model.dart';
import '../../domain/usecases/get_calendar_usecase.dart';

/// ----------------------------------------------------------------
/// UI State
/// ----------------------------------------------------------------

class CalendarUiState {
  const CalendarUiState({
    required this.focusedMonth,
    required this.selectedDate,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;

  CalendarUiState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
  }) {
    return CalendarUiState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

/// ----------------------------------------------------------------
/// UseCase Provider
/// ----------------------------------------------------------------

final getCalendarUseCaseProvider = Provider<GetCalendarUseCase>(
  (ref) {
    return GetCalendarUseCase(
      ref.read(habitRepositoryProvider),
    );
  },
);

/// ----------------------------------------------------------------
/// Calendar Notifier
/// ----------------------------------------------------------------

class CalendarNotifier extends AsyncNotifier<CalendarViewModel> {
  GetCalendarUseCase get _useCase => ref.read(getCalendarUseCaseProvider);

  CalendarUiState _uiState = CalendarUiState(
    focusedMonth: DateTime(
      DateTime.now().year,
      DateTime.now().month,
    ),
    selectedDate: DateTime.now(),
  );

  @override
  Future<CalendarViewModel> build() async {
    return _load();
  }

  Future<CalendarViewModel> _load() {
    return _useCase(
      focusedMonth: _uiState.focusedMonth,
      selectedDate: _uiState.selectedDate,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      _load,
    );
  }

  Future<void> selectDate(DateTime date) async {
    _uiState = _uiState.copyWith(
      selectedDate: DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );

    await refresh();
  }

  Future<void> nextMonth() async {
    final nextMonth = DateTime(
      _uiState.focusedMonth.year,
      _uiState.focusedMonth.month + 1,
    );

    _uiState = CalendarUiState(
      focusedMonth: nextMonth,
      selectedDate: DateTime(
        nextMonth.year,
        nextMonth.month,
        1,
      ),
    );

    await refresh();
  }

  Future<void> previousMonth() async {
    final previousMonth = DateTime(
      _uiState.focusedMonth.year,
      _uiState.focusedMonth.month - 1,
    );

    _uiState = CalendarUiState(
      focusedMonth: previousMonth,
      selectedDate: DateTime(
        previousMonth.year,
        previousMonth.month,
        1,
      ),
    );

    await refresh();
  }

  Future<void> jumpToToday() async {
    final today = DateTime.now();

    _uiState = CalendarUiState(
      focusedMonth: DateTime(
        today.year,
        today.month,
      ),
      selectedDate: today,
    );

    await refresh();
  }

  DateTime get focusedMonth => _uiState.focusedMonth;

  DateTime get selectedDate => _uiState.selectedDate;

  Future<void> openDate(DateTime date) async {
    _uiState = CalendarUiState(
      focusedMonth: DateTime(
        date.year,
        date.month,
      ),
      selectedDate: DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );

    await refresh();
  }
}

/// ----------------------------------------------------------------
/// Provider
/// ----------------------------------------------------------------

final calendarProvider =
    AsyncNotifierProvider<CalendarNotifier, CalendarViewModel>(
  CalendarNotifier.new,
);
