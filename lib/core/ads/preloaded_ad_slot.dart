import '../utils/app_logger.dart';
import 'full_screen_ad_gateway.dart';

/// Holds at most one preloaded full-screen ad.
///
/// Guarantees a single in-flight request (no load loops), discards
/// ads older than Google's one-hour expiry, and never throws.
class PreloadedAdSlot {
  PreloadedAdSlot({
    required this.label,
    required FullScreenAdLoader loader,
    required DateTime Function() clock,
  })  : _loader = loader,
        _clock = clock;

  /// Google: loaded full-screen ads expire after one hour.
  static const maxAge = Duration(minutes: 55);

  final String label;
  final FullScreenAdLoader _loader;
  final DateTime Function() _clock;

  LoadedFullScreenAd? _ad;
  DateTime? _loadedAt;
  Future<void>? _inFlight;
  bool _disposed = false;

  bool get isLoading => _inFlight != null;

  bool get hasAd {
    _dropIfExpired();
    return _ad != null;
  }

  Future<void> load(String adUnitId) {
    if (_disposed || hasAd) {
      return Future.value();
    }

    return _inFlight ??= _load(adUnitId).whenComplete(() {
      _inFlight = null;
    });
  }

  Future<void> _load(String adUnitId) async {
    try {
      final ad = await _loader.load(adUnitId);

      if (_disposed) {
        ad.dispose();
        return;
      }

      _ad = ad;
      _loadedAt = _clock();

      AppLogger.log('[Ads] $label loaded');
    } catch (error) {
      AppLogger.log('[Ads] $label failed to load: $error');
    }
  }

  /// Hands over the loaded ad (the caller now owns it), or null.
  LoadedFullScreenAd? take() {
    _dropIfExpired();

    final ad = _ad;
    _ad = null;
    _loadedAt = null;

    return ad;
  }

  void dispose() {
    _disposed = true;
    _ad?.dispose();
    _ad = null;
  }

  void _dropIfExpired() {
    final loadedAt = _loadedAt;

    if (_ad != null &&
        loadedAt != null &&
        _clock().difference(loadedAt) > maxAge) {
      AppLogger.log('[Ads] $label expired; discarded');
      _ad!.dispose();
      _ad = null;
      _loadedAt = null;
    }
  }
}
