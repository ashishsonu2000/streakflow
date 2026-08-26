import 'package:flutter/material.dart';

import '../../../../../core/ui/animations/fire_streak.dart';
import '../../../../../core/ui/progress/app_progress_bar.dart';

import '../../../domain/models/hero_view_model.dart';
import '../../../domain/models/user_summary.dart';

import '../../../widgets/hero/hero_stats.dart';
import 'hero_background.dart';
import 'hero_header.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.hero,
    required this.user,
  });

  final HeroViewModel hero;
  final UserSummary user;

  @override
  Widget build(BuildContext context) {
    final progress = hero.xpProgress.clamp(
      0.0,
      1.0,
    );

    return HeroBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          22,
          24,
          24,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =========================================================
            // HEADER
            // =========================================================

            HeroHeader(
              level: hero.level,
              greeting: user.greeting,
              userName: user.userName,
            ),

            const SizedBox(height: 22),

            // =========================================================
            // CURRENT STREAK
            // =========================================================

            Center(
              child: Column(
                children: [
                  const FireStreak(),

                  const SizedBox(height: 6),

                  TweenAnimationBuilder<int>(
                    tween: IntTween(
                      begin: 0,
                      end: hero.currentStreak,
                    ),
                    duration:
                    const Duration(
                      milliseconds: 900,
                    ),
                    curve:
                    Curves.easeOutCubic,
                    builder:
                        (context, value, child) {
                      return Text(
                        '$value',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                          height: 0.95,
                          fontWeight:
                          FontWeight.w900,
                          letterSpacing: -2,
                          shadows: [
                            Shadow(
                              color:
                              Colors.black26,
                              blurRadius: 18,
                              offset:
                              Offset(0, 5),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'DAY STREAK',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w500,
                      letterSpacing: 3.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _streakMessage(
                      hero.currentStreak,
                    ),
                    textAlign:
                    TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // XP / LEVEL PROGRESS
            // =========================================================

            AppProgressBar(
              value: progress,
              label: 'Level Progress',
              height: 9,
              color: Colors.amber,
              backgroundColor:
              Colors.white.withValues(
                alpha: 0.28,
              ),
              labelColor: Colors.white70,
              percentageColor: Colors.white,
              enableShimmer: true,
            ),

            const SizedBox(height: 24),

            // =========================================================
            // TODAY'S PROGRESS
            // =========================================================

            HeroStats(
              completed: hero.completedToday,
              total: hero.totalToday,
            ),
          ],
        ),
      ),
    );
  }

  String _streakMessage(int streak) {
    if (streak == 0) {
      return 'Start your streak today!';
    }

    if (streak == 1) {
      return 'Great start! Keep it going!';
    }

    if (streak < 7) {
      return 'Keep your momentum going!';
    }

    if (streak < 30) {
      return 'You are building a strong habit!';
    }

    if (streak < 100) {
      return 'Incredible consistency! Keep going!';
    }

    return 'Outstanding! You are unstoppable!';
  }
}