import 'package:flutter/foundation.dart';

@immutable
class XPResult {
  const XPResult({
    required this.totalXP,
    required this.level,
    required this.previousLevelXP,
    required this.nextLevelXP,
    required this.progress,
  });

  final int totalXP;
  final int level;
  final int previousLevelXP;
  final int nextLevelXP;

  /// 0.0 → 1.0
  final double progress;
}
