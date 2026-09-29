import 'dart:async';

import '../utils/app_logger.dart';
import 'full_screen_ad_gateway.dart';
import 'preloaded_ad_slot.dart';

// =====================================================================
// REWARDED AD SERVICE
//
// For an OPTIONAL, user-initiated exchange ("Watch an ad to unlock …").
// No feature uses it yet; add a reward only when there is a real,
// legitimate in-app benefit.
//
//   final rewarded = ref.read(rewardedAdServiceProvider);
//   await rewarded.preload();              // when the offer is visible
//   final result = await rewarded.show(
//     onReward: (reward) => unlockBonusInsight(),
//   );
//
// onReward is invoked at most once, and ONLY from the SDK's
// onUserEarnedReward callback. Premium users get
// RewardedAdResult.skippedPremium — the calling feature should grant
// its benefit to them directly, without an ad.
// =====================================================================

enum RewardedAdResult {
  rewarded,
  dismissedWithoutReward,
  notReady,
  unavailable,
  skippedPremium,
  failedToShow,
}

class RewardedAdService {
  RewardedAdService({
    required FullScreenAdLoader loader,
    required String? Function() adUnitId,
    required bool Function() isPremium,
    DateTime Function()? clock,
  })  : _adUnitId = adUnitId,
        _isPremium = isPremium,
        _slot = PreloadedAdSlot(
          label: 'Rewarded',
          loader: loader,
          clock: clock ?? DateTime.now,
        );

  final String? Function() _adUnitId;
  final bool Function() _isPremium;
  final PreloadedAdSlot _slot;

  bool _isShowing = false;

  bool get isLoaded => _slot.hasAd;

  bool get isLoading => _slot.isLoading;

  Future<void> preload() {
    final unitId = _adUnitId();

    if (unitId == null || _isPremium()) {
      return Future.value();
    }

    return _slot.load(unitId);
  }

  /// Never throws. Completes after the ad is closed.
  Future<RewardedAdResult> show({
    required void Function(AdReward reward) onReward,
  }) async {
    if (_isPremium()) {
      return RewardedAdResult.skippedPremium;
    }

    if (_adUnitId() == null) {
      return RewardedAdResult.unavailable;
    }

    if (_isShowing) {
      return RewardedAdResult.notReady;
    }

    final ad = _slot.take();

    if (ad == null) {
      unawaited(preload());
      return RewardedAdResult.notReady;
    }

    _isShowing = true;

    var rewardGranted = false;
    final completer = Completer<RewardedAdResult>();

    void finish(RewardedAdResult result) {
      _isShowing = false;
      if (!completer.isCompleted) completer.complete(result);
    }

    try {
      ad.show(
        onShown: () => AppLogger.log('[Ads] Rewarded displayed'),
        onUserEarnedReward: (reward) {
          if (rewardGranted) {
            return;
          }

          rewardGranted = true;
          AppLogger.log('[Ads] Reward earned');
          onReward(reward);
        },
        onDismissed: () {
          AppLogger.log('[Ads] Rewarded dismissed');
          finish(
            rewardGranted
                ? RewardedAdResult.rewarded
                : RewardedAdResult.dismissedWithoutReward,
          );
        },
        onFailedToShow: (message) {
          AppLogger.log('[Ads] Rewarded failed to show: $message');
          finish(RewardedAdResult.failedToShow);
        },
      );
    } catch (error) {
      AppLogger.log('[Ads] Rewarded show threw: $error');
      ad.dispose();
      finish(RewardedAdResult.failedToShow);
    }

    return completer.future;
  }

  void dispose() {
    _slot.dispose();
  }
}
