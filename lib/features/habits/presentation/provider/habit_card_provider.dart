import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/mappers/habit_card_mapper.dart';
import '../../domain/models/habit_card_view_model.dart';
import 'habit_providers.dart';

final habitCardMapperProvider = Provider(
  (ref) => const HabitCardMapper(),
);

final habitCardProvider = Provider<List<HabitCardViewModel>>((ref) {
  final habits = ref.watch(
    habitNotifierProvider,
  );

  final mapper = ref.watch(
    habitCardMapperProvider,
  );

  return habits.when(
    data: mapper.mapList,
    loading: () => const [],
    error: (_, __) => const [],
  );
});
