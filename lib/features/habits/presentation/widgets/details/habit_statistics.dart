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
        Expanded(
          child: AppStatTile(
            label: 'Current',
            value: '${habit.currentStreak}',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: AppStatTile(
            label: 'Best',
            value: '${habit.bestStreak}',
            icon: Icons.emoji_events_rounded,
            color: Colors.amber,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: AppStatTile(
            label: 'XP',
            value: '${habit.xp}',
            icon: Icons.stars_rounded,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}