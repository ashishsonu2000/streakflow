import '../models/hero_view_model.dart';

class DashboardInsightGenerator {
  const DashboardInsightGenerator();

  List<String> generate(HeroViewModel hero) {
    final insights = <String>[];

    // Completion
    if (hero.completedToday == hero.totalToday && hero.totalToday > 0) {
      insights.add('🎉 Amazing! You completed all habits for today.');
    } else if (hero.completedToday == 0) {
      insights.add('🚀 Start your first habit today and build momentum.');
    } else {
      insights.add(
        '✅ ${hero.completedToday}/${hero.totalToday} habits completed today.',
      );
    }

    // Streak
    if (hero.currentStreak >= 100) {
      insights.add(
        '🔥 Incredible! You have maintained a ${hero.currentStreak}-day streak.',
      );
    } else if (hero.currentStreak >= 30) {
      insights.add(
        '🔥 Fantastic! Your ${hero.currentStreak}-day streak is inspiring.',
      );
    } else if (hero.currentStreak >= 7) {
      insights.add(
        '👏 Great consistency! ${hero.currentStreak} days and counting.',
      );
    } else if (hero.currentStreak > 0) {
      insights.add(
        '💪 Keep going! Every day grows your streak.',
      );
    }

    // XP Progress
    if (hero.xpProgress >= 0.90) {
      insights.add(
        '⭐ You are almost at Level ${hero.level + 1}!',
      );
    } else if (hero.xpProgress >= 0.50) {
      insights.add(
        '📈 You are making solid progress toward the next level.',
      );
    }

    // Motivation
    if (hero.bestStreak > hero.currentStreak && hero.currentStreak > 0) {
      insights.add(
        '🎯 Only ${hero.bestStreak - hero.currentStreak} more days to match your best streak.',
      );
    }

    if (insights.isEmpty) {
      insights.add(
        '🌱 Small daily actions create extraordinary results.',
      );
    }

    return insights;
  }
}
