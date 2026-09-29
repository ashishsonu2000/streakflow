import 'package:flutter/foundation.dart';

// =====================================================================
// AD CONFIGURATION — single source of truth for ad unit IDs.
//
// Values come from --dart-define (or --dart-define-from-file), never
// from UI code. See docs/ADMOB_SETUP.md.
//
//   ADS_ENV                         disabled | test | production
//   ADMOB_ANDROID_BANNER_ID         AD UNIT ID  (ca-app-pub-XXX/YYY)
//   ADMOB_ANDROID_INTERSTITIAL_ID   AD UNIT ID
//   ADMOB_ANDROID_REWARDED_ID       AD UNIT ID
//   ADMOB_IOS_BANNER_ID             AD UNIT ID
//   ADMOB_IOS_INTERSTITIAL_ID       AD UNIT ID
//   ADMOB_IOS_REWARDED_ID           AD UNIT ID
//
// The ADMOB *APPLICATION* ID (ca-app-pub-XXX~YYY, note the "~") is a
// different value. It is not read here: it is injected into
// AndroidManifest.xml by android/app/build.gradle.kts
// (ADMOB_ANDROID_APP_ID) and into Info.plist by
// ios/Flutter/AdMob.xcconfig (ADMOB_IOS_APP_ID).
//
// When ADS_ENV is not set, debug/profile builds use Google's test ads
// and release builds have ads DISABLED, so a release can never ship
// with test IDs by accident.
// =====================================================================

enum AdEnvironment {
  /// No ad requests at all.
  disabled,

  /// Google's public test ad units. Safe for development and testing.
  test,

  /// Real ad units from the Streak Flow AdMob account.
  production,
}

/// Ad unit IDs for one platform.
@immutable
class AdUnitIds {
  const AdUnitIds({
    required this.banner,
    required this.interstitial,
    required this.rewarded,
  });

  final String banner;
  final String interstitial;
  final String rewarded;

  static const empty = AdUnitIds(
    banner: '',
    interstitial: '',
    rewarded: '',
  );
}

@immutable
class AdConfig {
  const AdConfig({
    required this.environment,
    required this.android,
    required this.ios,
  });

  final AdEnvironment environment;
  final AdUnitIds android;
  final AdUnitIds ios;

  // ===============================================================
  // GOOGLE TEST AD UNITS
  //
  // Published by Google for development:
  // https://developers.google.com/admob/flutter/test-ads
  // ===============================================================

  static const googleTestPublisherId = '3940256099942544';

  static const googleTestAndroid = AdUnitIds(
    banner: 'ca-app-pub-3940256099942544/9214589741',
    interstitial: 'ca-app-pub-3940256099942544/1033173712',
    rewarded: 'ca-app-pub-3940256099942544/5224354917',
  );

  static const googleTestIos = AdUnitIds(
    banner: 'ca-app-pub-3940256099942544/2435281174',
    interstitial: 'ca-app-pub-3940256099942544/4411468910',
    rewarded: 'ca-app-pub-3940256099942544/1712485313',
  );

  static const disabled = AdConfig(
    environment: AdEnvironment.disabled,
    android: AdUnitIds.empty,
    ios: AdUnitIds.empty,
  );

  bool get isEnabled => environment != AdEnvironment.disabled;

  bool get isTest => environment == AdEnvironment.test;

  /// Ad unit IDs for [platform], or null when ads are disabled or the
  /// platform is not supported by the Google Mobile Ads SDK.
  AdUnitIds? unitIdsFor(TargetPlatform platform) {
    if (!isEnabled) {
      return null;
    }

    switch (platform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return null;
    }
  }

  // ===============================================================
  // FROM --dart-define
  // ===============================================================

  factory AdConfig.fromEnvironment({
    void Function(String message)? onWarning,
  }) {
    return AdConfig.resolve(
      rawEnvironment: const String.fromEnvironment('ADS_ENV'),
      isReleaseBuild: kReleaseMode,
      productionAndroid: const AdUnitIds(
        banner: String.fromEnvironment('ADMOB_ANDROID_BANNER_ID'),
        interstitial:
            String.fromEnvironment('ADMOB_ANDROID_INTERSTITIAL_ID'),
        rewarded: String.fromEnvironment('ADMOB_ANDROID_REWARDED_ID'),
      ),
      productionIos: const AdUnitIds(
        banner: String.fromEnvironment('ADMOB_IOS_BANNER_ID'),
        interstitial: String.fromEnvironment('ADMOB_IOS_INTERSTITIAL_ID'),
        rewarded: String.fromEnvironment('ADMOB_IOS_REWARDED_ID'),
      ),
      platform: defaultTargetPlatform,
      onWarning: onWarning,
    );
  }

  /// Pure resolution logic, separated from [String.fromEnvironment]
  /// so it can be unit tested.
  ///
  /// Production never falls back to test IDs: if the production IDs
  /// for the running [platform] are missing or invalid, ads are
  /// disabled instead.
  static AdConfig resolve({
    required String rawEnvironment,
    required bool isReleaseBuild,
    required AdUnitIds productionAndroid,
    required AdUnitIds productionIos,
    required TargetPlatform platform,
    void Function(String message)? onWarning,
  }) {
    final environment = parseEnvironment(
      rawEnvironment,
      isReleaseBuild: isReleaseBuild,
    );

    switch (environment) {
      case AdEnvironment.disabled:
        return disabled;

      case AdEnvironment.test:
        return const AdConfig(
          environment: AdEnvironment.test,
          android: googleTestAndroid,
          ios: googleTestIos,
        );

      case AdEnvironment.production:
        final ids = platform == TargetPlatform.iOS
            ? productionIos
            : productionAndroid;

        final problems = validateProductionUnitIds(ids);

        if (problems.isNotEmpty) {
          onWarning?.call(
            'ADS_ENV=production but ad unit IDs are invalid '
            '(${problems.join(', ')}); ads disabled.',
          );
          return disabled;
        }

        return AdConfig(
          environment: AdEnvironment.production,
          android: productionAndroid,
          ios: productionIos,
        );
    }
  }

  static AdEnvironment parseEnvironment(
    String raw, {
    required bool isReleaseBuild,
  }) {
    switch (raw.trim().toLowerCase()) {
      case 'production':
      case 'prod':
        return AdEnvironment.production;
      case 'test':
        return AdEnvironment.test;
      case 'disabled':
      case 'off':
      case 'none':
        return AdEnvironment.disabled;
      default:
        return isReleaseBuild
            ? AdEnvironment.disabled
            : AdEnvironment.test;
    }
  }

  static final _adUnitIdPattern = RegExp(r'^ca-app-pub-\d{16}/\d{10}$');

  /// Returns the names of the production ad units that are missing,
  /// malformed, or still pointing at Google's test publisher.
  static List<String> validateProductionUnitIds(AdUnitIds ids) {
    final problems = <String>[];

    void check(String name, String value) {
      if (value.isEmpty) {
        problems.add('$name missing');
      } else if (value.contains(googleTestPublisherId)) {
        problems.add('$name is a Google test ID');
      } else if (!_adUnitIdPattern.hasMatch(value)) {
        problems.add('$name is not an ad unit ID');
      }
    }

    check('banner', ids.banner);
    check('interstitial', ids.interstitial);
    check('rewarded', ids.rewarded);

    return problems;
  }
}
