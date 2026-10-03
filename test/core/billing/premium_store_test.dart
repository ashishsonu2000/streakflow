import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/core/billing/billing_gateway.dart';
import 'package:streak_calculator_flutter/core/billing/premium_store.dart';
import 'package:streak_calculator_flutter/core/entitlements/entitlement_provider.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';

const _product = PremiumConfig.subscriptionProductId;

const _monthly = StorePlan(
  productId: _product,
  basePlanId: 'monthly',
  title: 'Monthly',
  formattedPrice: '₹99.00',
  billingPeriodLabel: 'per month',
);

class FakeBillingGateway implements BillingGateway {
  bool available = true;
  List<StorePlan> plans = const [_monthly];

  /// null = query fails (offline).
  List<BillingPurchase>? owned = const [];

  final updates = StreamController<List<BillingPurchase>>.broadcast();
  final completed = <BillingPurchase>[];
  final bought = <StorePlan>[];
  bool buyThrows = false;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<StorePlan>> loadPlans() async => plans;

  @override
  Stream<List<BillingPurchase>> get purchaseUpdates => updates.stream;

  @override
  Future<void> buy(StorePlan plan) async {
    if (buyThrows) throw StateError('billing client disconnected');
    bought.add(plan);
  }

  int queries = 0;

  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async {
    queries++;
    return owned;
  }

  @override
  Future<void> complete(BillingPurchase purchase) async =>
      completed.add(purchase);
}

BillingPurchase purchase(
  BillingPurchaseStatus status, {
  bool needsCompletion = true,
  String productId = _product,
}) =>
    BillingPurchase(
      productId: productId,
      status: status,
      needsCompletion: needsCompletion,
    );

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeBillingGateway gateway;
  late ProviderContainer container;
  late DateTime now;

  Future<void> start({Map<String, Object> prefs = const {}}) async {
    SharedPreferences.setMockInitialValues(prefs);
    final instance = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        billingGatewayProvider.overrideWithValue(gateway),
        sharedPreferencesProvider.overrideWithValue(instance),
        entitlementClockProvider.overrideWithValue(() => now),
        purchaseResultWaitProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(gateway.updates.close);

    await container.read(premiumStoreProvider.notifier).initialize();
  }

  PremiumStoreState store() => container.read(premiumStoreProvider);
  bool isPremium() => container.read(entitlementProvider).isPremium;

  String cachedPremium() =>
      '{"productId":"$_product","verifiedAt":"${now.toUtc().toIso8601String()}"}';

  setUp(() {
    gateway = FakeBillingGateway();
    now = DateTime(2026, 9, 30, 12);
  });

  group('Startup reconciliation', () {
    test('no purchases: ready, free', () async {
      await start();

      expect(store().status, PremiumStoreStatus.ready);
      expect(store().plans, [_monthly]);
      expect(isPremium(), isFalse);
    });

    test('owned subscription (reinstall): premium restored and acknowledged',
        () async {
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];

      await start();

      expect(isPremium(), isTrue);
      expect(gateway.completed, hasLength(1));
    });

    test('expired subscription: cached premium is revoked', () async {
      gateway.owned = const [];

      await start(prefs: {'premium_entitlement_v1': cachedPremium()});

      expect(isPremium(), isFalse);
    });

    test('offline: cached premium is kept', () async {
      gateway.owned = null;

      await start(prefs: {'premium_entitlement_v1': cachedPremium()});

      expect(isPremium(), isTrue);
    });

    test('pending purchase on startup: not premium, pending shown',
        () async {
      gateway.owned = [purchase(BillingPurchaseStatus.pending)];

      await start();

      expect(isPremium(), isFalse);
      expect(store().purchasePending, isTrue);
      expect(gateway.completed, isEmpty,
          reason: 'pending purchases must not be acknowledged');
    });

    test('store unavailable: unavailable, free, no crash', () async {
      gateway.available = false;

      await start();

      expect(store().status, PremiumStoreStatus.unavailable);
      expect(isPremium(), isFalse);
    });

    test('product not configured in Play Console: unavailable', () async {
      gateway.plans = const [];

      await start();

      expect(store().status, PremiumStoreStatus.unavailable);
      expect(store().canPurchase, isFalse);
      expect(store().message, contains('not available yet'));
    });

    test('initialization runs once', () async {
      await start();
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];

      await container.read(premiumStoreProvider.notifier).initialize();

      expect(isPremium(), isFalse);
    });
  });

  group('Purchase flow', () {
    test('purchased: premium granted, acknowledged, success message',
        () async {
      await start();

      await container.read(premiumStoreProvider.notifier).buy(_monthly);
      expect(gateway.bought, [_monthly]);
      expect(store().purchaseInProgress, isTrue);

      gateway.updates.add([purchase(BillingPurchaseStatus.purchased)]);
      await _settle();

      expect(isPremium(), isTrue);
      expect(gateway.completed, hasLength(1));
      expect(store().purchaseInProgress, isFalse);
      expect(store().message, contains('Welcome'));
    });

    test('pending: never grants until purchased', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      gateway.updates.add([purchase(BillingPurchaseStatus.pending)]);
      await _settle();

      expect(isPremium(), isFalse);
      expect(store().purchasePending, isTrue);
      expect(gateway.completed, isEmpty);

      gateway.updates.add([purchase(BillingPurchaseStatus.purchased)]);
      await _settle();

      expect(isPremium(), isTrue);
      expect(store().purchasePending, isFalse);
    });

    test('canceled: stays free, no error message', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      gateway.updates.add([
        purchase(BillingPurchaseStatus.canceled, needsCompletion: false),
      ]);
      await _settle();

      expect(isPremium(), isFalse);
      expect(store().purchaseInProgress, isFalse);
      expect(store().message, isNull);
    });

    test('error: stays free with a message', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      gateway.updates.add([purchase(BillingPurchaseStatus.error)]);
      await _settle();

      expect(isPremium(), isFalse);
      expect(store().message, contains('did not complete'));
    });

    test('purchase launch failure is reported, not thrown', () async {
      await start();
      gateway.buyThrows = true;

      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      expect(store().purchaseInProgress, isFalse);
      expect(store().message, contains('could not be started'));
    });

    test('a purchase of another product never grants Premium', () async {
      await start();

      gateway.updates.add([
        purchase(BillingPurchaseStatus.purchased, productId: 'other_sku'),
      ]);
      await _settle();

      expect(isPremium(), isFalse);
      expect(gateway.completed, hasLength(1),
          reason: 'still acknowledged so Play stops re-delivering it');
    });
  });

  group('Restore', () {
    test('active subscription found', () async {
      await start();
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];

      final found =
          await container.read(premiumStoreProvider.notifier).restore();

      expect(found, isTrue);
      expect(isPremium(), isTrue);
      expect(store().message, contains('restored'));
    });

    test('nothing to restore', () async {
      await start();

      final found =
          await container.read(premiumStoreProvider.notifier).restore();

      expect(found, isFalse);
      expect(isPremium(), isFalse);
      expect(store().message, contains('No active'));
    });

    test('offline: premium kept, message asks to retry', () async {
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];
      await start();
      expect(isPremium(), isTrue);

      gateway.owned = null;

      final found =
          await container.read(premiumStoreProvider.notifier).restore();

      expect(found, isFalse);
      expect(isPremium(), isTrue);
      expect(store().message, contains('Could not reach Google Play'));
    });
  });

  group('Purchase errors', () {
    test('"already owned" (subscribed elsewhere): premium restored, '
        'no failure message', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      // Play answers ITEM_ALREADY_OWNED; the subscription exists.
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];
      gateway.updates.add([purchase(BillingPurchaseStatus.error)]);
      await _settle();
      await _settle();

      expect(isPremium(), isTrue);
      expect(store().purchaseInProgress, isFalse);
      expect(store().message, contains('restored'));
    });

    test('a real failure still reports that nothing was charged', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      gateway.updates.add([purchase(BillingPurchaseStatus.error)]);
      await _settle();
      await _settle();

      expect(isPremium(), isFalse);
      expect(store().purchaseInProgress, isFalse);
      expect(store().message, contains('not been charged'));
    });
  });

  group('App returns to the foreground', () {
    Future<void> resume() =>
        container.read(premiumStoreProvider.notifier).onAppResumed();

    test('purchase result never arrived: purchases checked, buying '
        'enabled again', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);
      expect(store().purchaseInProgress, isTrue);

      await resume();

      expect(store().purchaseInProgress, isFalse);
      expect(store().canPurchase, isTrue);
      expect(isPremium(), isFalse);
    });

    test('purchase completed but its result was lost: premium unlocked',
        () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);

      gateway.owned = [purchase(BillingPurchaseStatus.restored)];
      await resume();

      expect(isPremium(), isTrue);
      expect(store().purchaseInProgress, isFalse);
      expect(store().message, contains('Welcome'));
    });

    test('result arrives normally: no extra check', () async {
      await start();
      await container.read(premiumStoreProvider.notifier).buy(_monthly);
      gateway.updates.add([purchase(BillingPurchaseStatus.purchased)]);
      await _settle();
      final queries = gateway.queries;

      await resume();

      expect(gateway.queries, queries);
      expect(isPremium(), isTrue);
    });

    test('recently verified: no new query', () async {
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];
      await start();
      final queries = gateway.queries;

      now = now.add(const Duration(hours: 5));
      await resume();

      expect(gateway.queries, queries);
    });

    test('verified long ago: expiry is noticed without a restart', () async {
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];
      await start();
      expect(isPremium(), isTrue);

      // Subscription expired while the app stayed open.
      gateway.owned = const [];
      now = now.add(PremiumConfig.storeRecheckInterval);
      await resume();

      expect(isPremium(), isFalse);
    });

    test('verified long ago but offline: premium kept', () async {
      gateway.owned = [purchase(BillingPurchaseStatus.restored)];
      await start();

      gateway.owned = null;
      now = now.add(const Duration(hours: 7));
      await resume();

      expect(isPremium(), isTrue);
    });

    test('store unavailable: nothing happens', () async {
      gateway.available = false;
      await start();

      await resume();

      expect(gateway.queries, 0);
    });
  });
}
