import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ads/ad_config.dart';
import '../../../../core/ads/ad_providers.dart';
import '../../../../core/ads/banner_ad_slot.dart';
import '../../../../core/ads/rewarded_ad_service.dart';
import '../../../../core/entitlements/entitlement_provider.dart';

/// Developer-only page (linked from Settings → Testing in non-release
/// builds) for exercising every ad format with Google TEST ads.
///
/// Never tap real (production) ads. See docs/ADMOB_SETUP.md.
class AdsTestPage extends ConsumerStatefulWidget {
  const AdsTestPage({super.key});

  @override
  ConsumerState<AdsTestPage> createState() => _AdsTestPageState();
}

class _AdsTestPageState extends ConsumerState<AdsTestPage> {
  int _rewardsGranted = 0;
  String _lastResult = '—';

  void _setResult(String result) {
    if (mounted) {
      setState(() => _lastResult = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = ref.watch(adConfigProvider);
    final adState = ref.watch(adsControllerProvider);
    final entitlement = ref.watch(entitlementProvider);
    final unitIds = ref.watch(activeAdUnitIdsProvider);
    final interstitial = ref.watch(interstitialAdServiceProvider);
    final rewarded = ref.watch(rewardedAdServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ads Test')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          _Info('Environment', config.environment.name),
          _Info('Status', adState.status.name),
          _Info('Reason', adState.reason?.name ?? '—'),
          _Info(
            'Privacy options required',
            '${adState.privacyOptionsRequired}',
          ),
          _Info('Entitlement', entitlement.name),
          _Info('Ads allowed now', '${unitIds != null}'),
          _Info('Interstitial policy', interstitial.evaluate().name),
          _Info('Rewards granted', '$_rewardsGranted'),
          _Info('Last result', _lastResult),

          if (config.environment == AdEnvironment.production)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'PRODUCTION ads are configured. Do not tap them.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          const Divider(height: 32),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Simulate premium'),
            subtitle: const Text('Debug builds only'),
            value: entitlement.isPremium,
            onChanged: kReleaseMode
                ? null
                : (value) {
                    ref.read(entitlementProvider.notifier).debugOverride(
                          value ? Entitlement.premium : Entitlement.free,
                        );
                  },
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  interstitial.recordMeaningfulAction();
                  setState(() {});
                },
                child: const Text('Record action'),
              ),
              OutlinedButton(
                onPressed: () async {
                  await interstitial.preload();
                  _setResult(
                    'Interstitial loaded: ${interstitial.isLoaded}',
                  );
                },
                child: const Text('Load interstitial'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  final shown = await interstitial.showIfEligible();
                  _setResult('Interstitial (policy) shown: $shown');
                },
                child: const Text('Show (policy)'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  final shown = await interstitial.showIfEligible(
                    ignorePolicy: true,
                  );
                  _setResult('Interstitial (forced) shown: $shown');
                },
                child: const Text('Show (ignore policy)'),
              ),
              OutlinedButton(
                onPressed: () async {
                  await rewarded.preload();
                  _setResult('Rewarded loaded: ${rewarded.isLoaded}');
                },
                child: const Text('Load rewarded'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  final result = await rewarded.show(
                    onReward: (reward) {
                      if (mounted) {
                        setState(() => _rewardsGranted++);
                      }
                    },
                  );
                  _setResult('Rewarded: ${result.name}');
                  if (result == RewardedAdResult.rewarded) {
                    await rewarded.preload();
                  }
                },
                child: const Text('Watch rewarded'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final error = await ref
                      .read(adsControllerProvider.notifier)
                      .showPrivacyOptions();
                  _setResult('Privacy options: ${error ?? 'ok'}');
                },
                child: const Text('Privacy options'),
              ),
            ],
          ),

          const Divider(height: 32),

          Text('Banner', style: theme.textTheme.titleSmall),

          const BannerAdSlot(),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
