import 'package:flutter/foundation.dart';

import 'premium_config.dart';
import 'premium_feature.dart';

/// The single policy that decides what the current user may use.
///
/// Pure and synchronous: build it from the current entitlement (see
/// featureAccessProvider) and ask it questions. UI, use cases and
/// services must not re-implement these rules.
@immutable
class FeatureAccess {
  const FeatureAccess({
    required this.isPremium,
    this.freeHabitLimit = PremiumConfig.freeHabitLimit,
  });

  final bool isPremium;
  final int freeHabitLimit;

  bool canUse(PremiumFeature feature) => isPremium;

  /// Null when unlimited.
  int? get activeHabitLimit => isPremium ? null : freeHabitLimit;

  /// Whether one more ACTIVE habit may be added (create, duplicate,
  /// onboarding suggestion or unarchive) given the current count.
  ///
  /// Editing, completing, archiving and deleting are never limited, and
  /// existing habits above the limit are never locked.
  bool canAddActiveHabit(int currentActiveHabits) {
    return isPremium || currentActiveHabits < freeHabitLimit;
  }

  @override
  bool operator ==(Object other) =>
      other is FeatureAccess &&
      other.isPremium == isPremium &&
      other.freeHabitLimit == freeHabitLimit;

  @override
  int get hashCode => Object.hash(isPremium, freeHabitLimit);
}
