import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../settings/presentation/widgets/settings_navigation_tile.dart';

/// Settings entry for StreakFlow Premium (upgrade or manage).
class PremiumSettingsTile extends ConsumerWidget {
  const PremiumSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(entitlementProvider).isPremium;

    return SettingsNavigationTile(
      icon: Icons.workspace_premium_outlined,
      title: 'StreakFlow Premium',
      subtitle: isPremium
          ? 'Active · Manage your subscription'
          : 'Free plan · Unlimited habits, insights and no ads',
      onTap: () => context.push(AppRoutes.premium),
    );
  }
}
