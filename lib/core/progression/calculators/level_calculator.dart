import '../models/level_summary.dart';

class LevelCalculator {
  const LevelCalculator();

  static const List<int> _thresholds = [
    0,
    200,
    450,
    750,
    1100,
    1500,
    1950,
    2450,
    3000,
    3600,
  ];

  LevelSummary calculate(int totalXp) {
    var level = 1;

    while (level < _thresholds.length && totalXp >= _thresholds[level]) {
      level++;
    }

    final previous = _thresholds[level - 1];

    final next = level == _thresholds.length ? previous : _thresholds[level];

    final currentXp = totalXp - previous;

    final remaining = level == _thresholds.length ? 0 : next - totalXp;

    final progress =
        level == _thresholds.length ? 1.0 : currentXp / (next - previous);

    return LevelSummary(
      level: level,
      totalXp: totalXp,
      previousLevelXp: previous,
      currentLevelXp: currentXp,
      nextLevelXp: next,
      remainingXp: remaining,
      progress: progress.clamp(0.0, 1.0),
    );
  }
}
