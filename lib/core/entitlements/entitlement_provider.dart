import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// =====================================================================
// ENTITLEMENTS
//
// What the current user is entitled to. Features (ads included) ask
// `ref.watch(entitlementProvider).isPremium` and never know how the
// entitlement was obtained.
//
// There is no purchase/subscription integration yet, so every user is
// FREE. When Google Play Billing / App Store subscriptions are added,
// only EntitlementNotifier.build() (and a verified purchase listener)
// needs to change.
//
// Development override (ignored in release builds):
//   --dart-define=DEV_ENTITLEMENT=premium
// =====================================================================

enum Entitlement {
  free,
  premium;

  bool get isPremium => this == Entitlement.premium;
}

class EntitlementNotifier extends Notifier<Entitlement> {
  @override
  Entitlement build() {
    if (!kReleaseMode &&
        const String.fromEnvironment('DEV_ENTITLEMENT') == 'premium') {
      return Entitlement.premium;
    }

    return Entitlement.free;
  }

  /// Development-only toggle used by the Ads Test page to verify the
  /// premium ad bypass. Has no effect in release builds.
  void debugOverride(Entitlement entitlement) {
    if (kReleaseMode) {
      return;
    }

    state = entitlement;
  }
}

final entitlementProvider =
    NotifierProvider<EntitlementNotifier, Entitlement>(
  EntitlementNotifier.new,
);
