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
// • Loads only while [active] (e.g. its shell tab is visible), so
//   off-screen IndexedStack tabs never request ads.
// • Loads once per widget; reloads only on a real width change.
// • After a failure it retries at most once per [_retryAfter], and
//   only when it becomes active again — no request loops.
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

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  void _maybeLoad(String? adUnitId, int width) {
    if (!widget.active || adUnitId == null || _loading || width <= 0) {
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

    final previous = _ad;

    BannerAd(
      adUnitId: adUnitId,
      size: AdSize.getInlineAdaptiveBannerAdSize(width, _maxAdHeight),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          final banner = ad as BannerAd;
          final size = await banner.getPlatformAdSize();

          if (!mounted || size == null) {
            banner.dispose();
            _loading = false;
            return;
          }

          AppLogger.log('[Ads] Banner loaded (${size.width}x${size.height})');

          setState(() {
            _ad = banner;
            _adSize = size;
            _loading = false;
            _failedAt = null;
          });

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

    // Premium activated, consent withdrawn, or ads disabled: drop any
    // loaded banner immediately.
    if (adUnitId == null) {
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
