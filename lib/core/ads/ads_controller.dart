import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entitlements/entitlement_provider.dart';
import '../utils/app_logger.dart';
import 'ad_providers.dart';
import 'models/ad_state.dart';

// =====================================================================
// ADS CONTROLLER
//
// Owns the once-per-session startup sequence:
//
//   config enabled? → free user? → UMP consent → canRequestAds?
//     → MobileAds.initialize() → ready
//
// Every failure ends in AdsStatus.unavailable. Nothing here is awaited
// by app startup, habit tracking, the database, or navigation — the
// app works identically (just without ads) when this never succeeds.
// =====================================================================

class AdsController extends Notifier<AdState> {
  Future<void>? _initialization;

  @override
  AdState build() {
    // A user who becomes free again (e.g. subscription lapsed) during
    // the session gets a fresh initialization attempt.
    ref.listen(entitlementProvider, (previous, next) {
      if (!next.isPremium &&
          state.reason == AdsUnavailableReason.premium) {
        _initialization = null;
        state = const AdState.idle();
        initialize();
      }
    });

    return const AdState.idle();
  }

  /// Safe to call repeatedly; the sequence runs at most once.
  Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    final config = ref.read(adConfigProvider);

    if (!config.isEnabled) {
      AppLogger.log('[Ads] Disabled by configuration (ADS_ENV)');
      state = const AdState(
        status: AdsStatus.unavailable,
        reason: AdsUnavailableReason.disabledByConfig,
      );
      return;
    }

    if (ref.read(entitlementProvider).isPremium) {
      AppLogger.log('[Ads] Premium user; skipping ad SDK');
      state = const AdState(
        status: AdsStatus.unavailable,
        reason: AdsUnavailableReason.premium,
      );
      return;
    }

    state = const AdState(status: AdsStatus.initializing);

    AppLogger.log(
      '[Ads] Initializing (environment: ${config.environment.name})',
    );

    try {
      final consent = ref.read(adConsentServiceProvider);

      final canRequestAds = await consent.gatherConsent();
      final privacyOptionsRequired =
          await consent.isPrivacyOptionsRequired();

      if (!canRequestAds) {
        state = AdState(
          status: AdsStatus.unavailable,
          reason: AdsUnavailableReason.consentNotGiven,
          privacyOptionsRequired: privacyOptionsRequired,
        );
        return;
      }

      await ref.read(mobileAdsInitializerProvider)();

      AppLogger.log('[Ads] SDK initialized');

      state = AdState(
        status: AdsStatus.ready,
        privacyOptionsRequired: privacyOptionsRequired,
      );
    } catch (error) {
      AppLogger.log('[Ads] SDK initialization failed: $error');

      state = AdState(
        status: AdsStatus.unavailable,
        reason: AdsUnavailableReason.initializationFailed,
        privacyOptionsRequired: state.privacyOptionsRequired,
      );
    }
  }

  /// Opens the UMP privacy options form, then re-reads consent so a
  /// withdrawal takes effect immediately. Returns an error message,
  /// or null on success.
  Future<String?> showPrivacyOptions() async {
    final consent = ref.read(adConsentServiceProvider);

    final error = await consent.showPrivacyOptionsForm();

    final canRequestAds = await consent.canRequestAds();

    if (!canRequestAds && state.isReady) {
      AppLogger.log('[Ads] Consent withdrawn; ads stopped');
      state = state.copyWith(
        status: AdsStatus.unavailable,
        reason: AdsUnavailableReason.consentNotGiven,
      );
    } else if (canRequestAds &&
        state.reason == AdsUnavailableReason.consentNotGiven) {
      _initialization = null;
      state = const AdState.idle();
      await initialize();
    }

    return error;
  }
}
