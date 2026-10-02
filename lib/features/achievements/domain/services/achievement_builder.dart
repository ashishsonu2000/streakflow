import 'package:flutter/material.dart';

import '../../../statistics/domain/models/statistics_summary.dart';

import '../enums/achievement_type.dart';
import '../models/achievement.dart';

class AchievementBuilder {
  const AchievementBuilder();

  /// [premiumUnlocked]: whether advanced (Premium) achievements can be
  /// unlocked. When false they are listed as premiumLocked.
  List<Achievement> build(
      StatisticsSummary statistics, {
      bool premiumUnlocked = false,
      }) {
    final overview = statistics.overview;

    // Best streak ever, so an earned streak achievement stays
    // unlocked after the streak breaks.
    final streak = overview.bestStreak > overview.currentStreak
        ? overview.bestStreak
        : overview.currentStreak;
    // All-time totals: totalCompletions/totalXP are TODAY's values,
    // which made completion/XP achievements unreachable and
    // "First Completion" re-lock every day.
    final completed = overview.lifetimeCompletions;
    final xp = overview.lifetimeXP;

    final createdHabits = statistics.performance.length;

    return [
      ..._base(statistics, streak, completed, xp, createdHabits),
      ..._premium(statistics, premiumUnlocked),
    ];
  }

  // ===========================================================
  // PREMIUM (advanced achievements)
  // ===========================================================

  List<Achievement> _premium(
      StatisticsSummary statistics,
      bool premiumUnlocked,
      ) {
    final overview = statistics.overview;

    Achievement premium({
      required AchievementType type,
      required String title,
      required String description,
      required IconData icon,
      required int current,
      required int target,
    }) {
      return Achievement(
        type: type,
        title: title,
        description: description,
        icon: icon,
        unlocked: premiumUnlocked && current >= target,
        progress: (current / target).clamp(0.0, 1.0),
        category: 'Premium',
        currentValue: current,
        targetValue: target,
        isPremium: true,
        premiumLocked: !premiumUnlocked,
      );
    }

    return [
      premium(
        type: AchievementType.bestStreak100,
        title: 'Unstoppable',
        description: 'Reach a 100-day best streak.',
        icon: Icons.local_fire_department_rounded,
        current: overview.bestStreak,
        target: 100,
      ),
      premium(
        type: AchievementType.completion500,
        title: 'Legend',
        description: 'Complete 500 habits.',
        icon: Icons.military_tech_outlined,
        current: overview.lifetimeCompletions,
        target: 500,
      ),
      premium(
        type: AchievementType.completion1000,
        title: 'Hall of Fame',
        description: 'Complete 1,000 habits.',
        icon: Icons.stars_rounded,
        current: overview.lifetimeCompletions,
        target: 1000,
      ),
      premium(
        type: AchievementType.xp5000,
        title: 'Grandmaster',
        description: 'Earn 5,000 XP.',
        icon: Icons.bolt_rounded,
        current: overview.lifetimeXP,
        target: 5000,
      ),
      premium(
        type: AchievementType.perfectDays30,
        title: 'Flawless',
        description: 'Have 30 perfect days.',
        icon: Icons.verified_rounded,
        current: overview.perfectDays,
        target: 30,
      ),
    ];
  }

  // ===========================================================
  // BASE (free) achievements — unchanged
  // ===========================================================

  List<Achievement> _base(
      StatisticsSummary statistics,
      int streak,
      int completed,
      int xp,
      int createdHabits,
      ) {
    return [
      // =========================================================
      // COMPLETION ACHIEVEMENTS
      // =========================================================

      Achievement(
        type: AchievementType.firstCompletion,
        title: 'First Completion',
        description: 'Complete your first habit.',
        icon: Icons.check_circle_outline,
        unlocked: completed >= 1,
        progress: (completed / 1).clamp(0.0, 1.0),
        category: 'Completion',
        currentValue: completed,
        targetValue: 1,
      ),

      Achievement(
        type: AchievementType.completion10,
        title: 'Productive',
        description: 'Complete 10 habits.',
        icon: Icons.task_alt,
        unlocked: completed >= 10,
        progress: (completed / 10).clamp(0.0, 1.0),
        category: 'Completion',
        currentValue: completed,
        targetValue: 10,
      ),

      Achievement(
        type: AchievementType.completion50,
        title: 'Champion',
        description: 'Complete 50 habits.',
        icon: Icons.emoji_events_outlined,
        unlocked: completed >= 50,
        progress: (completed / 50).clamp(0.0, 1.0),
        category: 'Completion',
        currentValue: completed,
        targetValue: 50,
      ),

      Achievement(
        type: AchievementType.completion100,
        title: 'Master',
        description: 'Complete 100 habits.',
        icon: Icons.workspace_premium_outlined,
        unlocked: completed >= 100,
        progress: (completed / 100).clamp(0.0, 1.0),
        category: 'Completion',
        currentValue: completed,
        targetValue: 100,
      ),

      // =========================================================
      // STREAK ACHIEVEMENTS
      // =========================================================

      Achievement(
        type: AchievementType.streak3,
        title: 'Getting Started',
        description: 'Maintain a 3-day streak.',
        icon: Icons.local_fire_department_outlined,
        unlocked: streak >= 3,
        progress: (streak / 3).clamp(0.0, 1.0),
        category: 'Streak',
        currentValue: streak,
        targetValue: 3,
      ),

      Achievement(
        type: AchievementType.streak7,
        title: 'Consistent',
        description: 'Maintain a 7-day streak.',
        icon: Icons.local_fire_department,
        unlocked: streak >= 7,
        progress: (streak / 7).clamp(0.0, 1.0),
        category: 'Streak',
        currentValue: streak,
        targetValue: 7,
      ),

      Achievement(
        type: AchievementType.streak30,
        title: 'Dedicated',
        description: 'Maintain a 30-day streak.',
        icon: Icons.whatshot,
        unlocked: streak >= 30,
        progress: (streak / 30).clamp(0.0, 1.0),
        category: 'Streak',
        currentValue: streak,
        targetValue: 30,
      ),

      // =========================================================
      // XP ACHIEVEMENTS
      // =========================================================

      Achievement(
        type: AchievementType.xp100,
        title: 'Rookie',
        description: 'Earn 100 XP.',
        icon: Icons.star_outline,
        unlocked: xp >= 100,
        progress: (xp / 100).clamp(0.0, 1.0),
        category: 'XP',
        currentValue: xp,
        targetValue: 100,
      ),

      Achievement(
        type: AchievementType.xp500,
        title: 'Explorer',
        description: 'Earn 500 XP.',
        icon: Icons.stars_outlined,
        unlocked: xp >= 500,
        progress: (xp / 500).clamp(0.0, 1.0),
        category: 'XP',
        currentValue: xp,
        targetValue: 500,
      ),

      Achievement(
        type: AchievementType.xp1000,
        title: 'Expert',
        description: 'Earn 1,000 XP.',
        icon: Icons.auto_awesome_outlined,
        unlocked: xp >= 1000,
        progress: (xp / 1000).clamp(0.0, 1.0),
        category: 'XP',
        currentValue: xp,
        targetValue: 1000,
      ),

      // =========================================================
      // SPECIAL ACHIEVEMENTS
      // =========================================================

      Achievement(
        type: AchievementType.habitCreator,
        title: 'Habit Creator',
        description: 'Create your first habit.',
        icon: Icons.edit_note_outlined,
        unlocked: createdHabits >= 1,
        progress: createdHabits >= 1 ? 1.0 : 0.0,
        category: 'Special',
        currentValue: createdHabits,
        targetValue: 1,
      ),

      Achievement(
        type: AchievementType.perfectWeek,
        title: 'Perfect Week',
        description: 'Reach 100% weekly completion.',
        icon: Icons.calendar_month_outlined,
        unlocked: statistics.weekly.completionRate >= 1.0,
        progress: statistics.weekly.completionRate.clamp(
          0.0,
          1.0,
        ),
        category: 'Special',
        currentValue:
        (statistics.weekly.completionRate * 100).round(),
        targetValue: 100,
      ),
    ];
  }
}