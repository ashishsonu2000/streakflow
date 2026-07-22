import 'package:flutter/material.dart';

import '../../../../../shared/widgets/cards/stat_tile.dart';
import '../../../domain/models/habit.dart';

class HabitStatistics extends StatelessWidget {
  const HabitStatistics({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppStatTile(
          label: 'Current',
          value: '${habit.currentStreak}',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
        const SizedBox(width: 12),
        AppStatTile(
          label: 'Best',
          value: '${habit.bestStreak}',
          icon: Icons.emoji_events,
          color: Colors.amber,
        ),
        const SizedBox(width: 12),
        AppStatTile(
          label: 'XP',
          value: '${habit.xp}',
          icon: Icons.star,
          color: Colors.green,
        ),
      ],
    );
  }
}
