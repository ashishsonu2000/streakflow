import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/core/entitlements/entitlement_cache.dart';
import 'package:streak_calculator_flutter/core/entitlements/entitlement_provider.dart';
import 'package:streak_calculator_flutter/core/entitlements/feature_access.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_feature.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ===================================================================
  // FEATURE ACCESS POLICY
  // ===================================================================

  group('FeatureAccess', () {
    const free = FeatureAccess(isPremium: false);
    const premium = FeatureAccess(isPremium: true);

    test('free limit comes from PremiumConfig', () {
      expect(free.activeHabitLimit, PremiumConfig.freeHabitLimit);
      expect(premium.activeHabitLimit, isNull);
    });

    test('free users may add habits only below the limit', () {
      final limit = PremiumConfig.freeHabitLimit;

      expect(free.canAddActiveHabit(0), isTrue);
      expect(free.canAddActiveHabit(limit - 1), isTrue);
      expect(free.canAddActiveHabit(limit), isFalse);
      expect(free.canAddActiveHabit(limit + 3), isFalse,
          reason: 'grandfathered users above the limit cannot add more');
    });

    test('premium users have unlimited habits', () {
      expect(premium.canAddActiveHabit(1000), isTrue);
    });

    test('every premium feature is locked for free and open for premium',
        () {
      for (final feature in PremiumFeature.values) {
        expect(free.canUse(feature), isFalse, reason: feature.name);
        expect(premium.canUse(feature), isTrue, reason: feature.name);
      }
    });
  });

  // ===================================================================
  // ENTITLEMENT RESOLUTION
  // ===================================================================

  group('EntitlementNotifier', () {
    late DateTime now;

    Future<ProviderContainer> container({
      Map<String, Object> prefs = const {},
      bool withPrefs = true,
    }) async {
      SharedPreferences.setMockInitialValues(prefs);
      final instance = await SharedPreferences.getInstance();

      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider
              .overrideWithValue(withPrefs ? instance : null),
          entitlementClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    String cached(DateTime verifiedAt) {
      final record = EntitlementRecord(
        productId: PremiumConfig.subscriptionProductId,
        verifiedAt: verifiedAt,
      );
      return '{"productId":"${record.productId}",'
          '"verifiedAt":"${record.verifiedAt.toUtc().toIso8601String()}"}';
    }

    setUp(() => now = DateTime(2026, 9, 30, 12));

    test('no cache: free', () async {
      final c = await container();

      expect(c.read(entitlementProvider), Entitlement.free);
      expect(c.read(featureAccessProvider).isPremium, isFalse);
    });

    test('no SharedPreferences available: free, no crash', () async {
      final c = await container(withPrefs: false);

      expect(c.read(entitlementProvider), Entitlement.free);
    });

    test('recently verified purchase: premium (offline)', () async {
      final c = await container(prefs: {
        'premium_entitlement_v1':
            cached(now.subtract(const Duration(days: 2))),
      });

      expect(c.read(entitlementProvider), Entitlement.premium);
    });

    test('verification older than the grace period: free', () async {
      final c = await container(prefs: {
        'premium_entitlement_v1': cached(
          now.subtract(
            PremiumConfig.offlineGracePeriod + const Duration(hours: 1),
          ),
        ),
      });

      expect(c.read(entitlementProvider), Entitlement.free);
    });

    test('verification dated in the future (clock tampering): free',
        () async {
      final c = await container(prefs: {
        'premium_entitlement_v1':
            cached(now.add(const Duration(days: 30))),
      });

      expect(c.read(entitlementProvider), Entitlement.free);
    });

    test('corrupt cache: free', () async {
      final c = await container(prefs: {
        'premium_entitlement_v1': 'not json',
      });

      expect(c.read(entitlementProvider), Entitlement.free);
    });

    test('grant persists and survives a restart', () async {
      final c = await container();

      await c
          .read(entitlementProvider.notifier)
          .grantVerifiedPurchase(productId: 'streakflow_premium');

      expect(c.read(entitlementProvider), Entitlement.premium);

      // Simulate an app restart with the same preferences.
      final prefs = await SharedPreferences.getInstance();
      final restarted = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          entitlementClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(restarted.dispose);

      expect(restarted.read(entitlementProvider), Entitlement.premium);
    });

    test('revoke clears the cache', () async {
      final c = await container(prefs: {
        'premium_entitlement_v1': cached(now),
      });

      await c.read(entitlementProvider.notifier).revokeAfterVerification();

      expect(c.read(entitlementProvider), Entitlement.free);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('premium_entitlement_v1'), isNull);
    });

    test('featureAccessProvider follows the entitlement', () async {
      final c = await container();

      expect(c.read(featureAccessProvider).canAddActiveHabit(10), isFalse);

      await c
          .read(entitlementProvider.notifier)
          .grantVerifiedPurchase(productId: 'streakflow_premium');

      expect(c.read(featureAccessProvider).canAddActiveHabit(10), isTrue);
    });
  });
}
