import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mapper/habit_card_view_model_mapper.dart';

final habitCardViewModelMapperProvider = Provider<HabitCardViewModelMapper>(
  (ref) => const HabitCardViewModelMapper(),
);
