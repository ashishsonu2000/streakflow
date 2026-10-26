import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
import 'package:streak_calculator_flutter/core/billing/app_store_billing_gateway.dart';
import 'package:streak_calculator_flutter/core/billing/play_billing_gateway.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';

void main() {
  test('App Store products map to the monthly / yearly plans', () {
    expect(
      AppStoreBillingMapping.basePlanId(
        PremiumConfig.appStoreMonthlyProductId,
      ),
      PremiumConfig.monthlyBasePlanId,
    );
    expect(
      AppStoreBillingMapping.basePlanId(PremiumConfig.appStoreYearlyProductId),
      PremiumConfig.yearlyBasePlanId,
    );
    expect(AppStoreBillingMapping.basePlanId('other_product'), isNull);
    expect(
      AppStoreBillingMapping.basePlanId(PremiumConfig.subscriptionProductId),
      isNull,
      reason: 'the Play product ID is not an App Store product',
    );
  });

  test('StoreKit periods read as the same labels as Google Play', () {
    String label(int value, SK2SubscriptionPeriodUnit unit) =>
        PlayBillingMapping.periodLabel(
          AppStoreBillingMapping.isoPeriod(
            SK2SubscriptionPeriod(value: value, unit: unit),
          ),
        );

    expect(label(1, SK2SubscriptionPeriodUnit.month), 'per month');
    expect(label(1, SK2SubscriptionPeriodUnit.year), 'per year');
    expect(label(1, SK2SubscriptionPeriodUnit.week), 'per week');
    expect(label(6, SK2SubscriptionPeriodUnit.month), 'every 6 months');
  });

  group('isUnexpired', () {
    final now = DateTime(2026, 10, 26, 12);
    String millis(DateTime d) => d.millisecondsSinceEpoch.toString();

    test('expires later: active', () {
      expect(
        AppStoreBillingMapping.isUnexpired(
          millis(now.add(const Duration(days: 3))),
          now,
        ),
        isTrue,
      );
    });

    test('already expired: inactive', () {
      expect(
        AppStoreBillingMapping.isUnexpired(
          millis(now.subtract(const Duration(minutes: 1))),
          now,
        ),
        isFalse,
      );
    });

    test('missing or unreadable date never grants', () {
      expect(AppStoreBillingMapping.isUnexpired(null, now), isFalse);
      expect(AppStoreBillingMapping.isUnexpired('', now), isFalse);
      expect(AppStoreBillingMapping.isUnexpired('soon', now), isFalse);
    });
  });
}
