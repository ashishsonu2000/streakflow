import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_card.dart';
import '../../../domain/models/habit_statistics.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String title;
    String message;
    IconData icon;
    Color color;

    if (statistics.currentStreak >= 30) {
      title = "Amazing!";
      message =
          "You're on an incredible ${statistics.currentStreak}-day streak.";
      icon = Icons.workspace_premium;
      color = Colors.amber;
    } else if (statistics.currentStreak >= 7) {
      title = "Great Progress";
      message =
          "You've maintained your habit for ${statistics.currentStreak} days.";
      icon = Icons.local_fire_department;
      color = Colors.orange;
    } else if (statistics.completionRate >= .80) {
      title = "Consistent";
      message =
          "Your completion rate is ${(statistics.completionRate * 100).round()}%. Keep it up!";
      icon = Icons.trending_up;
      color = Colors.green;
    } else {
      title = "Keep Going";
      message =
          "Small daily actions build lasting habits. Complete today's habit!";
      icon = Icons.flag_outlined;
      color = theme.colorScheme.primary;
    }

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: .15),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
