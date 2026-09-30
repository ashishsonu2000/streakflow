import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/entitlements/entitlement_provider.dart';
import '../../../core/entitlements/premium_feature.dart';
import '../../habits/presentation/providers/habit_limit_provider.dart';
import 'widgets/premium_upsell_sheet.dart';

/// UI-side checks before starting a gated action. The domain layer
/// enforces the same rules (HabitLimitGuard); these only turn a would-be
/// failure into a friendly upgrade prompt.
abstract final class PremiumGate {
  /// Before creating, duplicating or unarchiving a habit.
  /// Returns true when allowed; otherwise shows the upgrade prompt.
  static Future<bool> canAddActiveHabit(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final allowed =
        await ref.read(habitLimitGuardProvider).canAddActiveHabit();

    if (allowed) {
      return true;
    }

    if (context.mounted) {
      final limit = ref.read(featureAccessProvider).freeHabitLimit;

      await showPremiumUpsell(
        context,
        feature: PremiumFeature.unlimitedHabits,
        message: 'The Free plan includes up to $limit active habits. '
            'Upgrade to StreakFlow Premium for unlimited habits, or '
            'archive a habit to make room.',
      );
    }

    return false;
  }

  /// Before using any other Premium feature.
  static Future<bool> canUse(
    BuildContext context,
    WidgetRef ref,
    PremiumFeature feature,
  ) async {
    if (ref.read(featureAccessProvider).canUse(feature)) {
      return true;
    }

    if (context.mounted) {
      await showPremiumUpsell(context, feature: feature);
    }

    return false;
  }
}
