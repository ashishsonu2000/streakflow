import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/onboarding_data.dart';

class OnboardingNotifier extends Notifier<OnboardingData> {
  @override
  OnboardingData build() {
    return OnboardingData.empty;
  }

  void setName(String name) {
    state = state.copyWith(
      name: name,
    );
  }

  void toggleGoal(String goal) {
    final goals = List<String>.from(
      state.goals,
    );

    if (goals.contains(goal)) {
      goals.remove(goal);
    } else {
      goals.add(goal);
    }

    state = state.copyWith(
      goals: goals,
    );
  }

  void setNotifications(bool enabled) {
    state = state.copyWith(
      notificationsEnabled: enabled,
    );
  }

  void complete() {
    state = state.copyWith(
      completed: true,
    );
  }
}

final onboardingProvider =
NotifierProvider<
    OnboardingNotifier,
    OnboardingData>(
  OnboardingNotifier.new,
);