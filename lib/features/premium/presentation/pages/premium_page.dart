import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/routes.dart';
import '../../../../core/billing/billing_gateway.dart';
import '../../../../core/billing/premium_store.dart';
import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../../core/entitlements/premium_config.dart';
import '../../../../core/entitlements/premium_feature.dart';

/// StreakFlow Premium: benefits, plans from Google Play, purchase,
/// restore and subscription management.
class PremiumPage extends ConsumerStatefulWidget {
  const PremiumPage({super.key});

  @override
  ConsumerState<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends ConsumerState<PremiumPage> {
  String? _selectedBasePlanId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(premiumStoreProvider.notifier).initialize();
      }
    });
  }

  StorePlan? _selectedPlan(List<StorePlan> plans) {
    if (plans.isEmpty) {
      return null;
    }

    return plans.firstWhere(
      (p) => p.basePlanId == _selectedBasePlanId,
      orElse: () => plans.firstWhere(
        (p) => p.basePlanId == PremiumConfig.yearlyBasePlanId,
        orElse: () => plans.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(entitlementProvider).isPremium;
    final store = ref.watch(premiumStoreProvider);

    ref.listen(premiumStoreProvider.select((s) => s.message), (_, message) {
      if (message == null || !mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('StreakFlow Premium')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _Header(isPremium: isPremium),
            const SizedBox(height: 20),
            const _FeatureList(),
            const SizedBox(height: 20),
            if (isPremium)
              const _PremiumActive()
            else ...[
              if (store.purchasePending) const _PendingBanner(),
              _Plans(
                store: store,
                selected: _selectedPlan(store.plans),
                onSelect: (plan) =>
                    setState(() => _selectedBasePlanId = plan.basePlanId),
              ),
              const SizedBox(height: 16),
              _SubscribeButton(
                store: store,
                plan: _selectedPlan(store.plans),
              ),
              const SizedBox(height: 16),
              _Terms(plan: _selectedPlan(store.plans)),
            ],
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: store.purchaseInProgress ||
                        store.status == PremiumStoreStatus.loading
                    ? null
                    : () => ref.read(premiumStoreProvider.notifier).restore(),
                icon: const Icon(Icons.restore_rounded),
                label: const Text('Restore purchases'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => context.push(AppRoutes.terms),
                  child: const Text('Terms'),
                ),
                const Text('·'),
                TextButton(
                  onPressed: () => context.push(AppRoutes.privacy),
                  child: const Text('Privacy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// SECTIONS
// =====================================================================

class _Header extends StatelessWidget {
  const _Header({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            size: 48,
            color: colors.onPrimary,
          ),
          const SizedBox(height: 12),
          Text(
            isPremium ? 'You\'re on Premium' : 'StreakFlow Premium',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPremium
                ? 'Thank you for supporting StreakFlow.'
                : 'Everything in Free, plus deeper insights, unlimited '
                    'habits and no ads.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  static IconData _icon(PremiumFeature feature) => switch (feature) {
        PremiumFeature.unlimitedHabits => Icons.all_inclusive_rounded,
        PremiumFeature.adFree => Icons.block_rounded,
        PremiumFeature.productivityScore => Icons.speed_rounded,
        PremiumFeature.advancedInsights => Icons.insights_rounded,
        PremiumFeature.premiumReports => Icons.summarize_outlined,
        PremiumFeature.premiumThemes => Icons.palette_outlined,
        PremiumFeature.advancedAchievements =>
          Icons.emoji_events_outlined,
        PremiumFeature.csvExport => Icons.table_chart_outlined,
        PremiumFeature.multipleReminders =>
          Icons.notifications_active_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final feature in PremiumFeature.values)
              ListTile(
                leading: Icon(_icon(feature), color: colors.primary),
                title: Text(
                  feature == PremiumFeature.unlimitedHabits
                      ? '${feature.title} (Free: '
                          '${PremiumConfig.freeHabitLimit})'
                      : feature.title,
                  style: theme.textTheme.titleSmall,
                ),
                subtitle: Text(feature.description),
              ),
          ],
        ),
      ),
    );
  }
}

class _Plans extends StatelessWidget {
  const _Plans({
    required this.store,
    required this.selected,
    required this.onSelect,
  });

  final PremiumStoreState store;
  final StorePlan? selected;
  final ValueChanged<StorePlan> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (store.status == PremiumStoreStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (store.plans.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            store.message ??
                'StreakFlow Premium is not available yet. Please check '
                    'again later.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final plan in store.plans)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PlanTile(
              plan: plan,
              selected: identical(plan, selected),
              onTap: () => onSelect(plan),
            ),
          ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final StorePlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? colors.primaryContainer
                : colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? colors.primary : colors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? colors.primary : colors.outline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  plan.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.formattedPrice,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    plan.billingPeriodLabel,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscribeButton extends ConsumerWidget {
  const _SubscribeButton({required this.store, required this.plan});

  final PremiumStoreState store;
  final StorePlan? plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = this.plan;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: plan == null || !store.canPurchase
            ? null
            : () => ref.read(premiumStoreProvider.notifier).buy(plan),
        child: store.purchaseInProgress
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(
                plan == null
                    ? 'Subscribe'
                    : 'Subscribe · ${plan.formattedPrice} '
                        '${plan.billingPeriodLabel}',
              ),
      ),
    );
  }
}

class _Terms extends StatelessWidget {
  const _Terms({required this.plan});

  final StorePlan? plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plan = this.plan;

    final price = plan == null
        ? 'the price shown'
        : '${plan.formattedPrice} ${plan.billingPeriodLabel}';

    return Text(
      'Payment is charged to your Google Play account. The subscription '
      'renews automatically at $price unless cancelled at least 24 hours '
      'before the end of the current period. You can manage or cancel it '
      'anytime in Google Play → Payments & subscriptions.',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
    );
  }
}

class _PendingBanner extends StatelessWidget {
  const _PendingBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: colors.secondaryContainer,
      child: ListTile(
        leading: Icon(
          Icons.hourglass_top_rounded,
          color: colors.onSecondaryContainer,
        ),
        title: const Text('Payment pending'),
        subtitle: const Text(
          'Premium unlocks as soon as Google Play confirms your payment.',
        ),
      ),
    );
  }
}

class _PremiumActive extends StatelessWidget {
  const _PremiumActive();

  static final _manageUrl = Uri.parse(
    'https://play.google.com/store/account/subscriptions'
    '?sku=${PremiumConfig.subscriptionProductId}'
    '&package=com.codesapience.streakflow',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            launchUrl(_manageUrl, mode: LaunchMode.externalApplication),
        icon: const Icon(Icons.open_in_new_rounded),
        label: const Text('Manage subscription in Google Play'),
      ),
    );
  }
}
