import 'package:flutter/foundation.dart';

enum AdsStatus {
  /// Initialization has not been attempted yet.
  idle,

  /// Consent is being gathered / the SDK is starting.
  initializing,

  /// Ads may be requested.
  ready,

  /// Ads will not be requested this session (see [AdState.reason]).
  unavailable,
}

enum AdsUnavailableReason {
  disabledByConfig,
  premium,
  consentNotGiven,
  initializationFailed,
}

@immutable
class AdState {
  const AdState({
    required this.status,
    this.reason,
    this.privacyOptionsRequired = false,
  });

  const AdState.idle() : this(status: AdsStatus.idle);

  final AdsStatus status;
  final AdsUnavailableReason? reason;

  /// True when the User Messaging Platform requires an entry point
  /// for the user to change their consent choices (e.g. EEA/UK).
  final bool privacyOptionsRequired;

  bool get isReady => status == AdsStatus.ready;

  AdState copyWith({
    AdsStatus? status,
    AdsUnavailableReason? reason,
    bool? privacyOptionsRequired,
  }) {
    return AdState(
      status: status ?? this.status,
      reason: reason ?? this.reason,
      privacyOptionsRequired:
          privacyOptionsRequired ?? this.privacyOptionsRequired,
    );
  }

  @override
  String toString() =>
      'AdState($status, reason: $reason, '
      'privacyOptionsRequired: $privacyOptionsRequired)';
}
