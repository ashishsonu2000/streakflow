import 'package:flutter/foundation.dart';

@immutable
class XPLevel {
  const XPLevel({
    required this.level,
    required this.previousLevelXp,
    required this.nextLevelXp,
    required this.progress,
  });

  final int level;
  final int previousLevelXp;
  final int nextLevelXp;

  /// 0.0 → 1.0
  final double progress;
}
