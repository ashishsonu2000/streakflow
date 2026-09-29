import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/ads/full_screen_ad_gateway.dart';
import 'package:streak_calculator_flutter/core/ads/interstitial_ad_service.dart';
import 'package:streak_calculator_flutter/core/ads/interstitial_policy.dart';
import 'package:streak_calculator_flutter/core/ads/preloaded_ad_slot.dart';
import 'package:streak_calculator_flutter/core/ads/rewarded_ad_service.dart';

import 'fakes.dart';

void main() {
  const unitId = 'ca-app-pub-3940256099942544/0000000000';
  const reward = AdReward(type: 'insight', amount: 1);

  // ===================================================================
  // REWARDED
  // ===================================================================

  group('RewardedAdService', () {
    late FakeAdLoader loader;
    late bool premium;
    late String? activeUnitId;
    late RewardedAdService service;

    setUp(() {
      loader = FakeAdLoader();
      premium = false;
      activeUnitId = unitId;
      service = RewardedAdService(
        loader: loader,
        adUnitId: () => activeUnitId,
        isPremium: () => premium,
      );
    });

    test('reward is granted only on the SDK reward callback', () async {
      await service.preload();
      var granted = 0;

      final result = service.show(onReward: (_) => granted++);
      final ad = loader.loaded.single;

      ad.onShown!();
      expect(granted, 0, reason: 'showing the ad is not a reward');

      ad.onUserEarnedReward!(reward);
      ad.onDismissed!();

      expect(await result, RewardedAdResult.rewarded);
      expect(granted, 1);
    });

    test('dismissing early grants nothing', () async {
      await service.preload();
      var granted = 0;

      final result = service.show(onReward: (_) => granted++);
      loader.loaded.single
        ..onShown!()
        ..onDismissed!();

      expect(await result, RewardedAdResult.dismissedWithoutReward);
      expect(granted, 0);
    });

    test('late reward after dismiss is still reported as rewarded', () async {
      await service.preload();
      var granted = 0;

      final result = service.show(onReward: (_) => granted++);
      final ad = loader.loaded.single;

      ad.onDismissed!();
      ad.onUserEarnedReward!(reward);

      expect(await result, RewardedAdResult.rewarded);
      expect(granted, 1);
    });

    test('reward is granted at most once per ad', () async {
      await service.preload();
      var granted = 0;

      final result = service.show(onReward: (_) => granted++);
      loader.loaded.single
        ..onUserEarnedReward!(reward)
        ..onUserEarnedReward!(reward)
        ..onDismissed!();

      await result;
      expect(granted, 1);
    });

    test('failure to show grants nothing and does not throw', () async {
      await service.preload();
      var granted = 0;

      final result = service.show(onReward: (_) => granted++);
      loader.loaded.single.onFailedToShow!('internal error');

      expect(await result, RewardedAdResult.failedToShow);
      expect(granted, 0);
    });

    test('load failure yields notReady, never an exception', () async {
      loader.fail = true;
      await service.preload();

      expect(
        await service.show(onReward: (_) => fail('no reward expected')),
        RewardedAdResult.notReady,
      );
    });

    test('premium users skip the ad and nothing is loaded', () async {
      premium = true;
      await service.preload();

      expect(loader.loadCalls, 0);
      expect(
        await service.show(onReward: (_) {}),
        RewardedAdResult.skippedPremium,
      );
    });

    test('unavailable when ads may not be requested', () async {
      activeUnitId = null;
      await service.preload();

      expect(loader.loadCalls, 0);
      expect(
        await service.show(onReward: (_) {}),
        RewardedAdResult.unavailable,
      );
    });

    test('concurrent preloads issue a single request', () async {
      await Future.wait([service.preload(), service.preload()]);

      expect(loader.loadCalls, 1);
    });
  });

  // ===================================================================
  // INTERSTITIAL
  // ===================================================================

  group('InterstitialAdService', () {
    late FakeAdLoader loader;
    late DateTime now;
    late bool premium;
    late InterstitialAdService service;

    setUp(() {
      loader = FakeAdLoader();
      now = DateTime(2026, 9, 29, 9);
      premium = false;
      service = InterstitialAdService(
        loader: loader,
        policy: const InterstitialPolicy(),
        adUnitId: () => unitId,
        isPremium: () => premium,
        clock: () => now,
      );
    });

    void satisfyPolicy() {
      now = now.add(const Duration(minutes: 10));
      for (var i = 0; i < 6; i++) {
        service.recordMeaningfulAction();
      }
    }

    test('shows when policy allows, then enforces cooldown', () async {
      await service.preload();
      satisfyPolicy();

      final shown = service.showIfEligible();
      loader.loaded.single
        ..onShown!()
        ..onDismissed!();
      expect(await shown, isTrue);

      await service.preload();
      for (var i = 0; i < 6; i++) {
        service.recordMeaningfulAction();
      }

      expect(service.evaluate(), InterstitialDecision.cooldown);
      expect(await service.showIfEligible(), isFalse);
    });

    test('grace period is measured from the session start, not from '
        'when the service was created', () async {
      final lateService = InterstitialAdService(
        loader: loader,
        policy: const InterstitialPolicy(),
        adUnitId: () => unitId,
        isPremium: () => false,
        sessionStartedAt: now.subtract(const Duration(minutes: 10)),
        clock: () => now,
      );
      for (var i = 0; i < 6; i++) {
        lateService.recordMeaningfulAction();
      }

      expect(lateService.evaluate(), InterstitialDecision.allowed);
    });

    test('never shown during launch grace period', () async {
      await service.preload();
      for (var i = 0; i < 10; i++) {
        service.recordMeaningfulAction();
      }

      expect(await service.showIfEligible(), isFalse);
      expect(loader.loaded.single.showCalls, 0);
    });

    test('premium bypass: nothing loaded or shown', () async {
      premium = true;
      await service.preload();
      satisfyPolicy();

      expect(await service.showIfEligible(), isFalse);
      expect(loader.loadCalls, 0);
    });

    test('load failure is swallowed and nothing is shown', () async {
      loader.fail = true;
      await service.preload();
      satisfyPolicy();

      expect(await service.showIfEligible(), isFalse);
    });

    test('expired ads are discarded, never shown', () async {
      await service.preload();
      satisfyPolicy();
      now = now.add(PreloadedAdSlot.maxAge + const Duration(minutes: 1));

      expect(await service.showIfEligible(), isFalse);
      expect(loader.loaded.first.disposed, isTrue);
      expect(loader.loaded.first.showCalls, 0);
    });
  });
}
