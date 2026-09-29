import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/app_logger.dart';
import 'ad_providers.dart';

// =====================================================================
// BANNER AD SLOT
//
// Reusable inline adaptive banner for scrollable pages. Place it as the
// LAST item of the page content, away from habit actions and the
// navigation bar.
//
// • Renders nothing (zero height) until an ad has loaded, and nothing
//   at all for premium users, without consent, offline, or when ads
//   are disabled — the page layout is never blocked or reserved.
// • Exists only while actually on screen: its tab is [active], its
//   route is not covered by another page (TickerMode), and the app is
//   in the foreground. Otherwise the banner is disposed, because the
//   ad SDK cannot see that a Flutter platform view is hidden and would
//   keep auto-refreshing it (verified on device). It loads fresh when
//   visible again.
// • While visible, loads once; reloads only on a real width change
//   (rotation). AdMob's own auto-refresh is handled as a refresh.
// • After a failure it retries at most once per [_retryAfter] — no
//   request loops.
// =====================================================================

class BannerAdSlot extends ConsumerStatefulWidget {
  const BannerAdSlot({
    super.key,
    this.active = true,
    this.padding = const EdgeInsets.only(top: 16),
  });

  final bool active;
  final EdgeInsetsGeometry padding;

  @override
  ConsumerState<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends ConsumerState<BannerAdSlot> {
  static const _maxAdHeight = 100;
  static const _maxAdWidth = 728.0;
  static const _innerPadding = EdgeInsets.fromLTRB(8, 6, 8, 8);
  static const _retryAfter = Duration(minutes: 1);

  BannerAd? _ad;
  AdSize? _adSize;
  int? _requestedWidth;
  bool _loading = false;
  DateTime? _failedAt;

  /// Whether the slot was on screen at the last build.
  bool _visible = false;

  late final AppLifecycleListener _lifecycle;
  bool _appInForeground = true;

  @override
  void initState() {
    super.initState();

    final state = WidgetsBinding.instance.lifecycleState;
    _appInForeground = state == null || state == AppLifecycleState.resumed;

    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        final inForeground = state == AppLifecycleState.resumed;
        if (mounted && inForeground != _appInForeground) {
          setState(() => _appInForeground = inForeground);
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _ad?.dispose();
    super.dispose();
  }

  void _maybeLoad(String? adUnitId, int width) {
    if (!_visible || adUnitId == null || _loading || width <= 0) {
      return;
    }

    final failedAt = _failedAt;
    if (failedAt != null &&
        DateTime.now().difference(failedAt) < _retryAfter) {
      return;
    }

    final sameWidth =
        _requestedWidth != null && (_requestedWidth! - width).abs() <= 1;

    if (_ad != null && sameWidth) {
      return;
    }

    _loading = true;
    _requestedWidth = width;

    BannerAd(
      adUnitId: adUnitId,
      size: AdSize.getInlineAdaptiveBannerAdSize(width, _maxAdHeight),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          final banner = ad as BannerAd;

          // AdMob refreshes banners periodically and calls onAdLoaded
          // again for the SAME ad. That is not a new banner: keep it
          // (never dispose the live ad) and only pick up a new size.
          if (identical(banner, _ad)) {
            await _onRefreshed(banner);
            return;
          }

          AdSize? size;
          try {
            size = await banner.getPlatformAdSize();
          } catch (error) {
            AppLogger.log('[Ads] Banner size unavailable: $error');
          }

          // The page may be gone or hidden, or ads may have been
          // switched off (premium, consent withdrawn) while this
          // request was in flight: never keep a stale banner.
          final stillAllowed = mounted &&
              _visible &&
              ref.read(activeAdUnitIdsProvider) != null;

          if (!stillAllowed || size == null) {
            banner.dispose();
            _loading = false;
            if (size == null) _failedAt = DateTime.now();
            return;
          }

          AppLogger.log('[Ads] Banner loaded (${size.width}x${size.height})');

          final previous = _ad;

          setState(() {
            _ad = banner;
            _adSize = size;
            _loading = false;
            _failedAt = null;
          });

          // Replaced banner (width change): dispose after its AdWidget
          // has been unmounted.
          if (previous != null) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => previous.dispose(),
            );
          }
        },
        onAdFailedToLoad: (ad, error) {
          AppLogger.log(
            '[Ads] Banner failed: ${error.code} ${error.message}',
          );

          ad.dispose();
          _loading = false;
          _failedAt = DateTime.now();
        },
      ),
    ).load();
  }

  Future<void> _onRefreshed(BannerAd banner) async {
    AdSize? size;
    try {
      size = await banner.getPlatformAdSize();
    } catch (_) {
      // Keep the current size.
    }

    if (!mounted || !identical(banner, _ad)) {
      return;
    }

    AppLogger.log('[Ads] Banner refreshed');

    if (size != null &&
        (size.width != _adSize?.width || size.height != _adSize?.height)) {
      setState(() => _adSize = size);
    }
  }

  void _clear() {
    final ad = _ad;

    if (ad == null) {
      return;
    }

    // Dispose after this frame, once the AdWidget has been unmounted.
    WidgetsBinding.instance.addPostFrameCallback((_) => ad.dispose());

    _ad = null;
    _adSize = null;
    _requestedWidth = null;
  }

  @override
  Widget build(BuildContext context) {
    final adUnitId = ref.watch(activeAdUnitIdsProvider)?.banner;

    _visible = widget.active &&
        _appInForeground &&
        TickerMode.valuesOf(context).enabled;

    // Hidden, premium activated, consent withdrawn, or ads disabled:
    // drop any loaded banner immediately.
    if (adUnitId == null || !_visible) {
      _clear();
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = math.min(constraints.maxWidth, _maxAdWidth);
        final adWidth = (available - _innerPadding.horizontal - 2).floor();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _maybeLoad(adUnitId, adWidth);
          }
        });

        final ad = _ad;
        final size = _adSize;

        if (ad == null || size == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: widget.padding,
          child: Center(
            child: _AdContainer(
              padding: _innerPadding,
              child: SizedBox(
                width: size.width.toDouble(),
                height: size.height.toDouble(),
                child: AdWidget(ad: ad),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Neutral, clearly labelled frame so the ad is never mistaken for
/// Streak Flow content, buttons, or navigation.
class _AdContainer extends StatelessWidget {
  const _AdContainer({
    required this.padding,
    required this.child,
  });

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      container: true,
      label: 'Advertisement',
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 4),
              child: ExcludeSemantics(
                child: Text(
                  'Advertisement',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
