import 'package:flutter/foundation.dart';
import 'package:streak_calculator_flutter/core/ads/ad_consent_service.dart';
import 'package:streak_calculator_flutter/core/ads/full_screen_ad_gateway.dart';

/// Scripted full-screen ad. The test drives the SDK callbacks.
class FakeLoadedAd implements LoadedFullScreenAd {
  VoidCallback? onShown;
  VoidCallback? onDismissed;
  void Function(String message)? onFailedToShow;
  void Function(AdReward reward)? onUserEarnedReward;

  int showCalls = 0;
  bool disposed = false;

  @override
  void show({
    required VoidCallback onShown,
    required VoidCallback onDismissed,
    required void Function(String message) onFailedToShow,
    void Function(AdReward reward)? onUserEarnedReward,
  }) {
    showCalls++;
    this.onShown = onShown;
    this.onDismissed = onDismissed;
    this.onFailedToShow = onFailedToShow;
    this.onUserEarnedReward = onUserEarnedReward;
  }

  @override
  void dispose() => disposed = true;
}

class FakeAdLoader implements FullScreenAdLoader {
  FakeAdLoader({this.fail = false});

  bool fail;
  int loadCalls = 0;
  final List<FakeLoadedAd> loaded = [];

  @override
  Future<LoadedFullScreenAd> load(String adUnitId) async {
    loadCalls++;

    if (fail) {
      throw const AdLoadException('no fill');
    }

    final ad = FakeLoadedAd();
    loaded.add(ad);
    return ad;
  }
}

class FakeConsentService implements AdConsentService {
  FakeConsentService({
    this.canRequest = true,
    this.privacyRequired = false,
  });

  bool canRequest;
  bool privacyRequired;
  int gatherCalls = 0;

  @override
  Future<bool> gatherConsent() async {
    gatherCalls++;
    return canRequest;
  }

  @override
  Future<bool> canRequestAds() async => canRequest;

  @override
  Future<bool> isPrivacyOptionsRequired() async => privacyRequired;

  @override
  Future<String?> showPrivacyOptionsForm() async => null;
}
