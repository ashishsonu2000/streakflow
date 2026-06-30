import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../features/dashboard/domain/models/streak_summary.dart';
import '../badges/achievement_badge.dart';
import '../badges/level_badge.dart';
import '../indicators/app_progress_bar.dart';
import 'hero/hero_counter.dart';
import 'hero/hero_header.dart';
import 'hero/hero_stats.dart';

class HeroCard extends StatelessWidget {
  final StreakSummary streak;

  const HeroCard({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8A50),
            Color(0xFFFFA726),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.streakOrange.withOpacity(0.30),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const HeroHeader(),
          const SizedBox(height: 28),
          HeroCounter(
            streak: streak.currentStreak,
          ),
          const SizedBox(height: 28),
          AppProgressBar(
            value: streak.completion,
            progressColor: Colors.white,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(height: 24),
          HeroStats(
            completed: streak.completedDays,
            target: streak.targetDays,
            best: streak.longestStreak,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LevelBadge(level: streak.level),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AchievementBadge(
                    achievement: streak.achievement,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
