import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../../habits/presentation/providers/habit_limit_provider.dart';

import '../../domain/usecases/create_suggested_habit_usecase.dart';

final createSuggestedHabitProvider =
Provider(
      (ref) {
    return CreateSuggestedHabitUseCase(
      ref.read(
        habitRepositoryProvider,
      ),
      limitGuard: ref.read(habitLimitGuardProvider),
    );
  },
);