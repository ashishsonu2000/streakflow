import '../../../../core/progression/models/level_summary.dart';

class HeroSummary {
  const HeroSummary({
    required this.currentStreak,
    required this.bestStreak,
    required this.levelSummary,
    required this.title,
    required this.subtitle,
  });

  final int currentStreak;
  final int bestStreak;

  final LevelSummary levelSummary;

  final String title;
  final String subtitle;
}
