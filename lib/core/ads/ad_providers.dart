import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../entitlements/entitlement_provider.dart';
import '../utils/app_logger.dart';
import 'ad_config.dart';
import 'ad_consent_service.dart';
import 'ads_controller.dart';
import 'full_screen_ad_gateway.dart';
import 'interstitial_ad_service.dart';
import 'interstitial_policy.dart';
import 'models/ad_state.dart';
import 'rewarded_ad_service.dart';

// =====================================================================
// CONFIGURATION / PLATFORM SEAMS (overridden in tests)
// =====================================================================

final adConfigProvider = Provider<AdConfig>((ref) {
  return AdConfig.fromEnvironment(
    onWarning: (message) => AppLogger.log('[Ads] $message'),
  );
});

final adConsentServiceProvider = Provider<AdConsentService>((ref) {
  return const GoogleAdConsentService();
});

final mobileAdsInitializerProvider =
    Provider<Future<void> Function()>((ref) {
  return () async {
    await MobileAds.instance.initialize();
  };
});

final interstitialAdLoaderProvider = Provider<FullScreenAdLoader>((ref) {
  return const GoogleInterstitialAdLoader();
});

final rewardedAdLoaderProvider = Provider<FullScreenAdLoader>((ref) {
  return const GoogleRewardedAdLoader();
});

final interstitialPolicyProvider = Provider<InterstitialPolicy>((ref) {
  return const InterstitialPolicy();
});

/// When the user entered the main app this session (set when ads
/// initialize in MainShell). InterstitialPolicy's launch grace period
/// is measured from here.
final adSessionStartProvider = Provider<DateTime>((ref) {
  return DateTime.now();
});

// =====================================================================
// STATE
// =====================================================================

final adsControllerProvider = NotifierProvider<AdsController, AdState>(
  AdsController.new,
);

/// Ad unit IDs for the running platform, or null whenever ads must not
/// be requested (disabled, premium, no consent, SDK not ready).
/// This is the single gate every ad format goes through.
final activeAdUnitIdsProvider = Provider<AdUnitIds?>((ref) {
  final config = ref.watch(adConfigProvider);
  final isPremium = ref.watch(entitlementProvider).isPremium;
  final adState = ref.watch(adsControllerProvider);

  if (isPremium || !adState.isReady) {
    return null;
  }

  return config.unitIdsFor(defaultTargetPlatform);
});

// =====================================================================
// SERVICES
// =====================================================================

final interstitialAdServiceProvider = Provider<InterstitialAdService>((ref) {
  final service = InterstitialAdService(
    loader: ref.watch(interstitialAdLoaderProvider),
    policy: ref.watch(interstitialPolicyProvider),
    adUnitId: () => ref.read(activeAdUnitIdsProvider)?.interstitial,
    isPremium: () => ref.read(entitlementProvider).isPremium,
    sessionStartedAt: ref.read(adSessionStartProvider),
  );

  ref.onDispose(service.dispose);

  return service;
});

final rewardedAdServiceProvider = Provider<RewardedAdService>((ref) {
  final service = RewardedAdService(
    loader: ref.watch(rewardedAdLoaderProvider),
    adUnitId: () => ref.read(activeAdUnitIdsProvider)?.rewarded,
    isPremium: () => ref.read(entitlementProvider).isPremium,
  );

  ref.onDispose(service.dispose);

  return service;
});
