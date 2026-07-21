import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_card_view_model.dart';

import '../mapper/habit_card_view_model_mapper.dart';
import 'filtered_habits_provider.dart';

final habitCardListProvider =
    Provider<AsyncValue<List<HabitCardViewModel>>>((ref) {
  final habitsAsync = ref.watch(filteredHabitsProvider);

  const mapper = HabitCardViewModelMapper();

  return habitsAsync.whenData(
    (habits) => habits.map(mapper.map).toList(),
  );
});
