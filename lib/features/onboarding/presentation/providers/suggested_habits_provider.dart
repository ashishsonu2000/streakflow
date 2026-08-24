import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/profile_provider.dart';

import '../../domain/services/habit_suggestion_service.dart';

final suggestedHabitsProvider =
Provider(
      (ref) {
    final profile =
    ref.watch(profileProvider);

    return profile.when(
      data: (user) {
        return const HabitSuggestionService()
            .getSuggestions(
          user.goals,
        );
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);