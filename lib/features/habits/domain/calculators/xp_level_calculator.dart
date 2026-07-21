import '../models/xp_level.dart';

class XPLevelCalculator {
  const XPLevelCalculator._();

  static XPLevel calculate(int totalXp) {
    const xpPerLevel = 100;

    final level = (totalXp ~/ xpPerLevel) + 1;

    final previous = (level - 1) * xpPerLevel;

    final next = level * xpPerLevel;

    final progress = ((totalXp - previous) / (next - previous)).clamp(0.0, 1.0);

    return XPLevel(
      level: level,
      previousLevelXp: previous,
      nextLevelXp: next,
      progress: progress,
    );
  }
}
