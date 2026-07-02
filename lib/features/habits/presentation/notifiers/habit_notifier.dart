import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../data/entities/habit_frequency.dart';
import '../../domain/models/habit_category.dart';
import '../../usecases/create_habit_usecase.dart';
import '../provider/habit_providers.dart';

class HabitNotifier extends AsyncNotifier<List<Habit>> {
  late final HabitRepository _repository;
  late final CreateHabitUseCase _createHabit;
  @override
  Future<List<Habit>> build() async {
    _repository = ref.read(habitRepositoryProvider);
    _createHabit = ref.read(createHabitUseCaseProvider);

    return _repository.getAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getAll(),
    );
  }

  Future<void> addHabit({
    required String title,
    String description = '',
    HabitCategory category = HabitCategory.personal,
    HabitFrequency frequency = HabitFrequency.daily,
    int iconCodePoint = 0,
    int colorValue = 0,
    int targetPerDay = 1,
    bool reminderEnabled = false,
    int? reminderHour,
    int? reminderMinute,
  }) async {
    await _createHabit(
      title: title,
      description: description,
      category: category,
      frequency: frequency,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      targetPerDay: targetPerDay,
      reminderEnabled: reminderEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
    );

    await refresh();
  }

  Future<void> deleteHabit(String id) async {
    await _repository.delete(id);
    await refresh();
  }

  Future<void> archiveHabit(String id) async {
    await _repository.archive(id);
    await refresh();
  }

  Future<void> restoreHabit(String id) async {
    await _repository.restore(id);
    await refresh();
  }
}
