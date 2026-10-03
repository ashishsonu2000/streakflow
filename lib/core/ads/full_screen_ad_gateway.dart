import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// =====================================================================
// FULL-SCREEN AD GATEWAY
//
// Thin adapter over the Google Mobile Ads interstitial / rewarded APIs.
// The ad services depend only on these interfaces, so their policy,
// lifecycle, and reward rules are unit tested with fakes instead of
// the real ad network.
// =====================================================================

@immutable
class AdReward {
  const AdReward({
    required this.type,
    required this.amount,
  });

  final String type;
  final num amount;
}

class AdLoadException implements Exception {
  const AdLoadException(this.message);

  final String message;

  @override
  String toString() => 'AdLoadException: $message';
}

/// A loaded, not-yet-shown full-screen ad. Single use.
abstract interface class LoadedFullScreenAd {
  /// Presents the ad. Exactly one of [onDismissed] / [onFailedToShow]
  /// is called. [onUserEarnedReward] is only called by the SDK for
  /// rewarded ads, and only when the user earned the reward.
  void show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailedToShow,
    void Function(AdReward reward)? onUserEarnedReward,
  });

  void dispose();
}

abstract interface class FullScreenAdLoader {
  /// Throws [AdLoadException] when no ad could be loaded.
  Future<LoadedFullScreenAd> load(String adUnitId);
}

// =====================================================================
// INTERSTITIAL
// =====================================================================

class GoogleInterstitialAdLoader implements FullScreenAdLoader {
  const GoogleInterstitialAdLoader();

  @override
  Future<LoadedFullScreenAd> load(String adUnitId) {
    final completer = Completer<LoadedFullScreenAd>();

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => completer.complete(_GoogleInterstitial(ad)),
        onAdFailedToLoad: (error) => completer.completeError(
          AdLoadException('${error.code} ${error.message}'),
        ),
      ),
    );

    return completer.future;
  }
}

class _GoogleInterstitial implements LoadedFullScreenAd {
  _GoogleInterstitial(this._ad);

  final InterstitialAd _ad;

  @override
  void show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailedToShow,
    void Function(AdReward reward)? onUserEarnedReward,
  }) {
    _ad.fullScreenContentCallback = _callbacks(
      onShown: onShown,
      onDismissed: onDismissed,
      onFailedToShow: onFailedToShow,
    );

    _ad.show();
  }

  @override
  void dispose() => _ad.dispose();
}

// =====================================================================
// REWARDED
// =====================================================================

class GoogleRewardedAdLoader implements FullScreenAdLoader {
  const GoogleRewardedAdLoader();

  @override
  Future<LoadedFullScreenAd> load(String adUnitId) {
    final completer = Completer<LoadedFullScreenAd>();

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => completer.complete(_GoogleRewarded(ad)),
        onAdFailedToLoad: (error) => completer.completeError(
          AdLoadException('${error.code} ${error.message}'),
        ),
      ),
    );

    return completer.future;
  }
}

class _GoogleRewarded implements LoadedFullScreenAd {
  _GoogleRewarded(this._ad);

  final RewardedAd _ad;

  @override
  void show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailedToShow,
    void Function(AdReward reward)? onUserEarnedReward,
  }) {
    _ad.fullScreenContentCallback = _callbacks(
      onShown: onShown,
      onDismissed: onDismissed,
      onFailedToShow: onFailedToShow,
    );

    _ad.show(
      onUserEarnedReward: (_, reward) {
        onUserEarnedReward?.call(
          AdReward(type: reward.type, amount: reward.amount),
        );
      },
    );
  }

  @override
  void dispose() => _ad.dispose();
}

FullScreenContentCallback<T> _callbacks<T extends Ad>({
  required VoidCallback onShown,
  required VoidCallback onDismissed,
  required void Function(String message) onFailedToShow,
}) {
  return FullScreenContentCallback<T>(
    onAdShowedFullScreenContent: (_) => onShown(),
    onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      onDismissed();
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      onFailedToShow('${error.code} ${error.message}');
    },
  );
}
