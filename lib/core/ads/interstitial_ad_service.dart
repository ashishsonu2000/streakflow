import 'dart:async';

import '../utils/app_logger.dart';
import 'full_screen_ad_gateway.dart';
import 'interstitial_policy.dart';
import 'preloaded_ad_slot.dart';

// =====================================================================
// INTERSTITIAL AD SERVICE
//
// Usage from a feature (at a natural break only — see
// InterstitialPolicy):
//
//   final ads = ref.read(interstitialAdServiceProvider);
//   ads.recordMeaningfulAction();          // e.g. after a review session
//   await ads.preload();                   // ahead of the break
//   await ads.showIfEligible();            // at the break; never throws
//
// Nothing in the app calls showIfEligible() yet; no interstitial will
// appear until a placement is deliberately chosen.
// =====================================================================

class InterstitialAdService {
  InterstitialAdService({
    required FullScreenAdLoader loader,
    required this.policy,
    required String? Function() adUnitId,
    required bool Function() isPremium,
    DateTime Function()? clock,
  })  : _adUnitId = adUnitId,
        _isPremium = isPremium,
        _clock = clock ?? DateTime.now {
    _sessionStartedAt = _clock();
    _slot = PreloadedAdSlot(
      label: 'Interstitial',
      loader: loader,
      clock: _clock,
    );
  }

  final InterstitialPolicy policy;

  /// Null whenever ads may not be requested (disabled, premium, no
  /// consent, SDK not ready).
  final String? Function() _adUnitId;
  final bool Function() _isPremium;
  final DateTime Function() _clock;

  late final DateTime _sessionStartedAt;
  late final PreloadedAdSlot _slot;

  DateTime? _lastShownAt;
  int _actionsSinceLastShow = 0;
  int _shownThisSession = 0;
  bool _isShowing = false;

  bool get isLoaded => _slot.hasAd;

  void recordMeaningfulAction() {
    _actionsSinceLastShow++;
  }

  InterstitialDecision evaluate() {
    return policy.evaluate(
      now: _clock(),
      sessionStartedAt: _sessionStartedAt,
      lastShownAt: _lastShownAt,
      meaningfulActionsSinceLastShow: _actionsSinceLastShow,
      shownThisSession: _shownThisSession,
      isPremium: _isPremium(),
      adsAvailable: _adUnitId() != null,
    );
  }

  Future<void> preload() {
    final unitId = _adUnitId();

    if (unitId == null || _isPremium()) {
      return Future.value();
    }

    return _slot.load(unitId);
  }

  /// Shows a preloaded interstitial if the policy allows it.
  /// Completes with true once the ad was dismissed, false if nothing
  /// was shown. Never throws and never waits for a network load.
  ///
  /// [ignorePolicy] exists only for the debug Ads Test page.
  Future<bool> showIfEligible({bool ignorePolicy = false}) async {
    if (_isShowing) {
      return false;
    }

    final decision = evaluate();

    final allowed = decision == InterstitialDecision.allowed ||
        (ignorePolicy &&
            decision != InterstitialDecision.premium &&
            decision != InterstitialDecision.adsUnavailable);

    if (!allowed) {
      AppLogger.log('[Ads] Interstitial not shown: ${decision.name}');
      return false;
    }

    final ad = _slot.take();

    if (ad == null) {
      AppLogger.log('[Ads] Interstitial not shown: not loaded');
      unawaited(preload());
      return false;
    }

    _isShowing = true;
    final completer = Completer<bool>();

    try {
      ad.show(
        onShown: () {
          AppLogger.log('[Ads] Interstitial displayed');
          _lastShownAt = _clock();
          _actionsSinceLastShow = 0;
          _shownThisSession++;
        },
        onDismissed: () {
          AppLogger.log('[Ads] Interstitial dismissed');
          _isShowing = false;
          if (!completer.isCompleted) completer.complete(true);
        },
        onFailedToShow: (message) {
          AppLogger.log('[Ads] Interstitial failed to show: $message');
          _isShowing = false;
          if (!completer.isCompleted) completer.complete(false);
        },
      );
    } catch (error) {
      AppLogger.log('[Ads] Interstitial show threw: $error');
      ad.dispose();
      _isShowing = false;
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future;
  }

  void dispose() {
    _slot.dispose();
  }
}
