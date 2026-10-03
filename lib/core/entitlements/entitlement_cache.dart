import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The last Premium entitlement that Google Play confirmed on this
/// device. Lets Premium keep working offline for a limited period.
@immutable
class EntitlementRecord {
  const EntitlementRecord({
    required this.productId,
    required this.verifiedAt,
  });

  final String productId;

  /// When Google Play last reported an active, purchased subscription.
  final DateTime verifiedAt;

  bool isValidAt(DateTime now, Duration gracePeriod) {
    return now.isBefore(verifiedAt.add(gracePeriod)) &&
        !now.isBefore(verifiedAt.subtract(const Duration(days: 1)));
  }

  Map<String, Object> toJson() => {
        'productId': productId,
        'verifiedAt': verifiedAt.toUtc().toIso8601String(),
      };

  static EntitlementRecord? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return EntitlementRecord(
        productId: json['productId'] as String,
        verifiedAt: DateTime.parse(json['verifiedAt'] as String).toLocal(),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Persists [EntitlementRecord] in SharedPreferences.
///
/// Stores no purchase tokens, order IDs or personal data.
class EntitlementCache {
  const EntitlementCache(this._prefs);

  static const _key = 'premium_entitlement_v1';

  final SharedPreferences _prefs;

  EntitlementRecord? read() => EntitlementRecord.tryParse(_prefs.getString(_key));

  Future<void> write(EntitlementRecord record) {
    return _prefs.setString(_key, jsonEncode(record.toJson()));
  }

  Future<void> clear() => _prefs.remove(_key);
}
