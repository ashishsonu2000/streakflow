import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/habit_frequency.dart';
import '../../domain/models/create_habit_request.dart';
import '../../domain/models/habit_category.dart';

import '../provider/habit_providers.dart';

class HabitNotifier extends AsyncNotifier<void> {
  @override
  void build() {}

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
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(createHabitUseCaseProvider)(
        CreateHabitRequest(
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
        ),
      );
    });
  }

  Future<void> completeHabit(String habitId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(completeHabitUseCaseProvider)(habitId);
    });
  }

  Future<void> uncompleteHabit(String habitId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(uncompleteUseCaseProvider)(habitId);
    });
  }

  Future<void> deleteHabit(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(deleteHabitUseCaseProvider)(id);
    });
  }

  Future<void> archiveHabit(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(archiveHabitUseCaseProvider)(id);
    });
  }

  Future<void> restoreHabit(String id) async {
    state = const AsyncLoading();

    try {
      state = await AsyncValue.guard(() async {
        await ref.read(restoreHabitUseCaseProvider)(id);
      });
    } catch (e, stack) {
      debugPrint("RestoreHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }
}
