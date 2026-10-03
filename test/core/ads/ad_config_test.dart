import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/ads/ad_config.dart';

void main() {
  const realAndroid = AdUnitIds(
    banner: 'ca-app-pub-1234567890123456/1111111111',
    interstitial: 'ca-app-pub-1234567890123456/2222222222',
    rewarded: 'ca-app-pub-1234567890123456/3333333333',
  );

  AdConfig resolve(
    String env, {
    bool release = false,
    AdUnitIds android = AdUnitIds.empty,
    AdUnitIds ios = AdUnitIds.empty,
    TargetPlatform platform = TargetPlatform.android,
    bool allowProductionInDebug = false,
    void Function(String)? onWarning,
  }) {
    return AdConfig.resolve(
      rawEnvironment: env,
      isReleaseBuild: release,
      productionAndroid: android,
      productionIos: ios,
      platform: platform,
      allowProductionInDebug: allowProductionInDebug,
      onWarning: onWarning,
    );
  }

  group('environment defaults', () {
    test('debug build without ADS_ENV uses Google test ads', () {
      final config = resolve('');

      expect(config.environment, AdEnvironment.test);
      expect(
        config.unitIdsFor(TargetPlatform.android),
        AdConfig.googleTestAndroid,
      );
    });

    test('release build without ADS_ENV disables ads (never test IDs)', () {
      final config = resolve('', release: true);

      expect(config.environment, AdEnvironment.disabled);
      expect(config.unitIdsFor(TargetPlatform.android), isNull);
    });

    test('ADS_ENV=disabled disables ads', () {
      expect(resolve('disabled').isEnabled, isFalse);
    });
  });

  group('test mode', () {
    test('uses Google test IDs on both platforms, even in release', () {
      final config = resolve('test', release: true, android: realAndroid);

      expect(
        config.unitIdsFor(TargetPlatform.android)!.banner,
        contains(AdConfig.googleTestPublisherId),
      );
      expect(
        config.unitIdsFor(TargetPlatform.iOS),
        AdConfig.googleTestIos,
      );
    });
  });

  group('production mode', () {
    test('debug build cannot use production IDs by accident', () {
      final warnings = <String>[];
      final config = resolve(
        'production',
        android: realAndroid,
        onWarning: warnings.add,
      );

      expect(config.environment, AdEnvironment.test);
      expect(
        config.unitIdsFor(TargetPlatform.android),
        AdConfig.googleTestAndroid,
      );
      expect(warnings, hasLength(1));
    });

    test('debug build uses production IDs only with explicit opt-in', () {
      final config = resolve(
        'production',
        android: realAndroid,
        allowProductionInDebug: true,
      );

      expect(config.unitIdsFor(TargetPlatform.android), realAndroid);
    });

    test('uses the configured production IDs', () {
      final config = resolve('production', release: true, android: realAndroid);

      expect(config.environment, AdEnvironment.production);
      expect(config.unitIdsFor(TargetPlatform.android), realAndroid);
    });

    test('missing production IDs disable ads instead of using test IDs', () {
      final warnings = <String>[];
      final config = resolve(
        'production',
        release: true,
        onWarning: warnings.add,
      );

      expect(config.environment, AdEnvironment.disabled);
      expect(warnings, hasLength(1));
    });

    test('Google test IDs are rejected as production IDs', () {
      final config = resolve(
        'production',
        release: true,
        android: AdConfig.googleTestAndroid,
      );

      expect(config.isEnabled, isFalse);
    });

    test('an app ID (with ~) is rejected as an ad unit ID', () {
      final problems = AdConfig.validateProductionUnitIds(
        const AdUnitIds(
          banner: 'ca-app-pub-1234567890123456~1111111111',
          interstitial: 'ca-app-pub-1234567890123456/2222222222',
          rewarded: 'ca-app-pub-1234567890123456/3333333333',
        ),
      );

      expect(problems, ['banner is not an ad unit ID']);
    });

    test('unsupported platforms get no ad units', () {
      final config = resolve('production', release: true, android: realAndroid);

      expect(config.unitIdsFor(TargetPlatform.windows), isNull);
    });
  });
}
