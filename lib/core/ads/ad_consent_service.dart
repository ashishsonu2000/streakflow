import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/app_logger.dart';

// =====================================================================
// CONSENT — Google User Messaging Platform (UMP)
//
// Follows https://developers.google.com/admob/flutter/privacy:
//   1. requestConsentInfoUpdate() on every launch
//   2. loadAndShowConsentFormIfRequired()
//   3. canRequestAds() before initializing MobileAds / loading ads
//   4. expose showPrivacyOptionsForm() when the requirement status is
//      `required` (Settings → Ad privacy choices)
//
// The consent message itself (GDPR / US state regulations) is
// configured in AdMob → Privacy & messaging. This class never renders
// its own consent UI.
//
// Development-only debug geography (ignored in release builds):
//   --dart-define=UMP_DEBUG_GEOGRAPHY=eea
//   --dart-define=UMP_TEST_DEVICE_ID=<hashed id printed in logcat>
// =====================================================================

abstract interface class AdConsentService {
  /// Updates consent info and shows the consent form if required.
  /// Returns whether ads may be requested. Never throws.
  Future<bool> gatherConsent();

  /// Current consent state without showing any UI. Never throws.
  Future<bool> canRequestAds();

  Future<bool> isPrivacyOptionsRequired();

  /// Shows the UMP privacy options form. Returns an error message,
  /// or null on success.
  Future<String?> showPrivacyOptionsForm();
}

class GoogleAdConsentService implements AdConsentService {
  const GoogleAdConsentService();

  @override
  Future<bool> gatherConsent() async {
    try {
      final updateError = await _requestConsentInfoUpdate();

      if (updateError != null) {
        // Offline or UMP unavailable: fall back to the consent state
        // stored from a previous session.
        AppLogger.log('[Ads] Consent info update failed: $updateError');
      } else {
        final completer = Completer<FormError?>();

        await ConsentForm.loadAndShowConsentFormIfRequired(
          completer.complete,
        );

        final formError = await completer.future;

        if (formError != null) {
          AppLogger.log(
            '[Ads] Consent form error: '
            '${formError.errorCode} ${formError.message}',
          );
        }
      }

      final canRequestAds =
          await ConsentInformation.instance.canRequestAds();

      AppLogger.log(
        '[Ads] Consent status: '
        '${await ConsentInformation.instance.getConsentStatus()}, '
        'canRequestAds: $canRequestAds',
      );

      return canRequestAds;
    } catch (error) {
      AppLogger.log('[Ads] Consent gathering failed: $error');
      return false;
    }
  }

  @override
  Future<bool> canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } catch (error) {
      AppLogger.log('[Ads] canRequestAds failed: $error');
      return false;
    }
  }

  @override
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      return await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (error) {
      AppLogger.log('[Ads] Privacy options status failed: $error');
      return false;
    }
  }

  @override
  Future<String?> showPrivacyOptionsForm() async {
    try {
      final completer = Completer<FormError?>();

      await ConsentForm.showPrivacyOptionsForm(completer.complete);

      final error = await completer.future;

      return error?.message;
    } catch (error) {
      AppLogger.log('[Ads] Privacy options form failed: $error');
      return 'Privacy options are unavailable right now.';
    }
  }

  // ===============================================================
  // HELPERS
  // ===============================================================

  Future<String?> _requestConsentInfoUpdate() {
    final completer = Completer<String?>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      _requestParameters(),
      () => completer.complete(null),
      (error) => completer.complete(
        '${error.errorCode} ${error.message}',
      ),
    );

    return completer.future;
  }

  ConsentRequestParameters _requestParameters() {
    if (kReleaseMode) {
      return ConsentRequestParameters();
    }

    const geography = String.fromEnvironment('UMP_DEBUG_GEOGRAPHY');
    const testDeviceId = String.fromEnvironment('UMP_TEST_DEVICE_ID');

    if (geography.isEmpty) {
      return ConsentRequestParameters();
    }

    return ConsentRequestParameters(
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: switch (geography.toLowerCase()) {
          'eea' => DebugGeography.debugGeographyEea,
          'us_state' => DebugGeography.debugGeographyRegulatedUsState,
          'other' => DebugGeography.debugGeographyOther,
          _ => DebugGeography.debugGeographyDisabled,
        },
        testIdentifiers: testDeviceId.isEmpty ? null : [testDeviceId],
      ),
    );
  }
}
