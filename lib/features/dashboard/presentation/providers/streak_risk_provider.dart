import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';

import '../../domain/services/streak_risk_service.dart';

final streakRiskProvider =
Provider(
      (ref) {
    final habitsAsync = ref.watch(
      habitsProvider,
    );

    return habitsAsync.when(
      data: (habits) {
        return const StreakRiskService()
            .find(
          habits,
        );
      },
      loading: () => null,
      error: (_, __) => null,
    );
  },
);