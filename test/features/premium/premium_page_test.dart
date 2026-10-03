import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/core/billing/billing_gateway.dart';
import 'package:streak_calculator_flutter/core/billing/premium_store.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_feature.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';
import 'package:streak_calculator_flutter/features/premium/presentation/pages/premium_page.dart';

import '../../core/billing/premium_store_test.dart' show FakeBillingGateway;

void main() {
  late FakeBillingGateway gateway;

  Future<void> pump(WidgetTester tester) async {
    // Tall window so the whole (lazy) page is built.
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          billingGatewayProvider.overrideWithValue(gateway),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(home: PremiumPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => gateway = FakeBillingGateway());

  testWidgets('free user sees every feature, the plan price and terms',
      (tester) async {
    await pump(tester);

    for (final feature in PremiumFeature.values) {
      expect(find.textContaining(feature.title), findsWidgets,
          reason: feature.name);
    }
    expect(find.text('₹99.00'), findsOneWidget);
    expect(find.textContaining('renews automatically'), findsOneWidget);
    expect(find.text('Restore purchases'), findsOneWidget);
  });

  testWidgets('subscribe launches the Google Play purchase for the plan',
      (tester) async {
    await pump(tester);

    await tester.tap(find.textContaining('Subscribe ·'));
    await tester.pump();

    expect(gateway.bought.single.basePlanId, 'monthly');
  });

  testWidgets('premium not configured yet: message and subscribe disabled',
      (tester) async {
    gateway.plans = const [];
    await pump(tester);

    expect(find.textContaining('not available yet'), findsWidgets);

    final button = tester.widget<FilledButton>(
      find.ancestor(
        of: find.textContaining('Subscribe'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('premium user sees manage subscription, not subscribe',
      (tester) async {
    gateway.owned = const [
      BillingPurchase(
        productId: PremiumConfig.subscriptionProductId,
        status: BillingPurchaseStatus.restored,
      ),
    ];
    await pump(tester);

    expect(find.text('You\'re on Premium'), findsOneWidget);
    expect(find.textContaining('Subscribe'), findsNothing);
  });
}
