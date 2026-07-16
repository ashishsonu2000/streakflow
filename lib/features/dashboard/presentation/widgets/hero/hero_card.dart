import 'package:flutter/material.dart';

import '../../../../../core/ui/progress/app_progress_bar.dart';
import '../../../domain/models/hero_view_model.dart';

import 'hero_background.dart';
import 'hero_header.dart';

import 'hero_stats.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.hero,
  });

  final HeroViewModel hero;

  @override
  Widget build(BuildContext context) {
    return HeroBackground(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroHeader(
              level: hero.level,
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Text(
                    "${hero.currentStreak}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "DAY STREAK",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Keep your momentum going!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 28),
            AppProgressBar(
              value: hero.xpProgress,
              label: "Level Progress",
            ),
            const SizedBox(height: 30),
            HeroStats(
              completed: hero.completedToday,
              total: hero.totalToday,
              best: hero.bestStreak,
            ),
          ],
        ),
      ),
    );
  }
}
