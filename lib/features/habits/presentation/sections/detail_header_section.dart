import 'package:flutter/material.dart';

import '../../domain/models/habit_detail.dart';

class DetailHeaderSection extends StatelessWidget {
  const DetailHeaderSection({
    super.key,
    required this.detail,
  });

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final habit = detail.habit;

    final color = Color(habit.colorValue);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Hero(
              tag: 'habit_${habit.id}',
              child: CircleAvatar(
                radius: 42,
                backgroundColor: color,
                child: Icon(
                  IconData(
                    habit.iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              habit.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (habit.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                habit.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.local_fire_department,
                    value: "${habit.currentStreak}",
                    label: "Current",
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _Stat(
                    icon: Icons.emoji_events,
                    value: "${habit.bestStreak}",
                    label: "Best",
                    color: Colors.amber,
                  ),
                ),
                Expanded(
                  child: _Stat(
                    icon: Icons.stars,
                    value: "${habit.xp}",
                    label: "XP",
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
