import '../../../../core/progression/models/level_summary.dart';
import '../models/dashboard_analytics.dart';
import '../models/hero_summary.dart';

class HeroSummaryCalculator {
  const HeroSummaryCalculator();

  HeroSummary calculate(
    DashboardAnalytics analytics,
  ) {
    final LevelSummary level = analytics.levelSummary;

    return HeroSummary(
      currentStreak: analytics.currentStreak,
      bestStreak: analytics.longestStreak,
      levelSummary: level,
      title: '${analytics.currentStreak} Day Streak',
      subtitle: level.remainingXp == 0
          ? 'Level Complete'
          : 'Only ${level.remainingXp} XP until Level ${level.level + 1}',
    );
  }
}
