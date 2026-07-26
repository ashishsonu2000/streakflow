import 'package:flutter/material.dart';

import '../../../../core/ui/avatars/app_avatar.dart';
import '../../domain/models/today_habit_view_model.dart';
import 'completion_button.dart';
import 'habit_chip.dart';
import 'habit_progress.dart';

class TodayHabitCard extends StatelessWidget {
  const TodayHabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onComplete,
  });

  final TodayHabitViewModel habit;

  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------------------
            // Top Row
            //------------------------------------------------

            Row(
              children: [
                Hero(
                  tag: habit.id,
                  child: AppAvatar(
                    icon: habit.icon,
                    color: habit.color,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${habit.durationMinutes} min session",
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                CompletionButton(
                  completed: habit.completed,
                  onPressed: onComplete,
                ),
              ],
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // Chips
            //------------------------------------------------

            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                HabitChip(
                  icon: Icons.local_fire_department,
                  label: "${habit.currentStreak} Day Streak",
                  color: Colors.orange,
                ),
                HabitChip(
                  icon: Icons.timer_outlined,
                  label: "${habit.durationMinutes} min",
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // Progress
            //------------------------------------------------

            HabitProgress(
              value: habit.progress,
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                habit.progressLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: habit.completed
                      ? Colors.green
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
