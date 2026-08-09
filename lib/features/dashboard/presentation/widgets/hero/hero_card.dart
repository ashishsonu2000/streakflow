import 'package:flutter/material.dart';

import '../../../../../core/ui/animations/fire_streak.dart';
import '../../../../../core/ui/progress/app_progress_bar.dart';
import '../../../domain/models/hero_view_model.dart';
import '../../../domain/models/user_summary.dart';

import '../../../widgets/hero/hero_header.dart';
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
    return HeroBackground(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 HEADER
            HeroHeader(
              level: hero.level,
              greeting: user.greeting,
              userName: user.userName,
            ),

            const SizedBox(height: 28),

            /// 🔥 MAIN STREAK WITH FIRE ANIMATION
            /// 🔥 MAIN STREAK (FIXED CLEAN VERSION)
            Center(
              child: Column(
                children: [
                  /// 🔥 GLOWING FIRE
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.2),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const FireStreak(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  /// 🔢 BIG NUMBER WITH SHADOW
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: hero.currentStreak),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return Text(
                        "$value",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 76,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "DAY STREAK",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 SUBTITLE
            const Center(
              child: Text(
                "Keep your momentum going!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 28),

            /// 🔥 PROGRESS
            AppProgressBar(
              value: hero.xpProgress.clamp(0.0, 1.0),
              label: "Level Progress",
            ),

            const SizedBox(height: 28),

            /// 🔥 STATS
            HeroStats(
              completed: hero.completedToday,
              total: hero.totalToday,
              best: hero.bestStreak,
              target: hero.target,
            ),
          ],
        ),
      ),
    );
  }
}