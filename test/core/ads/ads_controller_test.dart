import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/ads/ad_config.dart';
import 'package:streak_calculator_flutter/core/ads/ad_providers.dart';
import 'package:streak_calculator_flutter/core/ads/banner_ad_slot.dart';
import 'package:streak_calculator_flutter/core/ads/models/ad_state.dart';
import 'package:streak_calculator_flutter/core/entitlements/entitlement_provider.dart';

import 'fakes.dart';

const _testConfig = AdConfig(
  environment: AdEnvironment.test,
  android: AdConfig.googleTestAndroid,
  ios: AdConfig.googleTestIos,
);

class _PremiumEntitlement extends EntitlementNotifier {
  @override
  Entitlement build() => Entitlement.premium;
}

ProviderContainer _container({
  AdConfig config = _testConfig,
  FakeConsentService? consent,
  Future<void> Function()? sdkInit,
  bool premium = false,
}) {
  final container = ProviderContainer(
    overrides: [
      adConfigProvider.overrideWithValue(config),
      adConsentServiceProvider.overrideWithValue(
        consent ?? FakeConsentService(),
      ),
      mobileAdsInitializerProvider.overrideWithValue(
        sdkInit ?? () async {},
      ),
      if (premium)
        entitlementProvider.overrideWith(_PremiumEntitlement.new),
    ],
  );

  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Free vs premium', () {
    test('free user: ads enabled after consent + SDK init', () async {
      final container = _container();

      await container.read(adsControllerProvider.notifier).initialize();

      expect(container.read(adsControllerProvider).status, AdsStatus.ready);
      expect(container.read(activeAdUnitIdsProvider), isNotNull);
    });

    test('premium user: ads disabled and SDK never touched', () async {
      final consent = FakeConsentService();
      var sdkInitCalls = 0;
      final container = _container(
        premium: true,
        consent: consent,
        sdkInit: () async => sdkInitCalls++,
      );

      await container.read(adsControllerProvider.notifier).initialize();

      expect(
        container.read(adsControllerProvider).reason,
        AdsUnavailableReason.premium,
      );
      expect(container.read(activeAdUnitIdsProvider), isNull);
      expect(consent.gatherCalls, 0);
      expect(sdkInitCalls, 0);
    });

    test('becoming premium mid-session removes ads immediately', () async {
      final container = _container();
      await container.read(adsControllerProvider.notifier).initialize();

      container
          .read(entitlementProvider.notifier)
          .debugOverride(Entitlement.premium);

      expect(container.read(activeAdUnitIdsProvider), isNull);
    });
  });

  group('Initialization failures never throw', () {
    test('no consent: ads unavailable, SDK not initialized', () async {
      var sdkInitCalls = 0;
      final container = _container(
        consent: FakeConsentService(canRequest: false, privacyRequired: true),
        sdkInit: () async => sdkInitCalls++,
      );

      await container.read(adsControllerProvider.notifier).initialize();

      final state = container.read(adsControllerProvider);
      expect(state.reason, AdsUnavailableReason.consentNotGiven);
      expect(state.privacyOptionsRequired, isTrue);
      expect(sdkInitCalls, 0);
    });

    test('SDK init failure (e.g. offline): ads unavailable', () async {
      final container = _container(
        sdkInit: () async => throw Exception('network down'),
      );

      await container.read(adsControllerProvider.notifier).initialize();

      expect(
        container.read(adsControllerProvider).reason,
        AdsUnavailableReason.initializationFailed,
      );
      expect(container.read(activeAdUnitIdsProvider), isNull);
    });

    test('disabled config: nothing is initialized', () async {
      final consent = FakeConsentService();
      final container = _container(config: AdConfig.disabled, consent: consent);

      await container.read(adsControllerProvider.notifier).initialize();

      expect(
        container.read(adsControllerProvider).reason,
        AdsUnavailableReason.disabledByConfig,
      );
      expect(consent.gatherCalls, 0);
    });

    test('initialization runs at most once per session', () async {
      final consent = FakeConsentService();
      final container = _container(consent: consent);
      final controller = container.read(adsControllerProvider.notifier);

      await Future.wait([controller.initialize(), controller.initialize()]);
      await controller.initialize();

      expect(consent.gatherCalls, 1);
    });
  });

  group('BannerAdSlot', () {
    testWidgets('renders nothing and keeps the page intact when ads are '
        'unavailable', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adConfigProvider.overrideWithValue(_testConfig),
            adConsentServiceProvider.overrideWithValue(
              FakeConsentService(canRequest: false),
            ),
            mobileAdsInitializerProvider.overrideWithValue(() async {}),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Habit content'),
                  BannerAdSlot(),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Habit content'), findsOneWidget);
      expect(find.text('Advertisement'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
