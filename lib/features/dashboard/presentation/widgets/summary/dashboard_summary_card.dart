import 'package:flutter/material.dart';

import '../../../domain/models/hero_view_model.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    super.key,
    required this.hero,
  });

  final HeroViewModel hero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final remaining =
        (hero.totalToday - hero.completedToday).clamp(0, hero.totalToday);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "💡 Today's Summary",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _SummaryTile(
              icon: Icons.check_circle,
              color: Colors.green,
              title:
                  "${hero.completedToday} of ${hero.totalToday} habits completed",
            ),
            _SummaryTile(
              icon: Icons.local_fire_department,
              color: Colors.orange,
              title: "${hero.currentStreak} day streak",
            ),
            _SummaryTile(
              icon: Icons.star,
              color: Colors.amber,
              title: "${hero.totalXP} XP earned",
            ),
            _SummaryTile(
              icon: Icons.flag,
              color: Colors.blue,
              title: remaining == 0
                  ? "Today's goal completed 🎉"
                  : "$remaining habit${remaining == 1 ? '' : 's'} remaining",
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.color,
    required this.title,
  });

  final IconData icon;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
