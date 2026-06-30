import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';

import '../dashboard/domain/models/habit_summary.dart';
import 'habit_footer.dart';
import 'habit_icon.dart';

class HabitCard extends StatelessWidget {
  final HabitSummary habit;

  final VoidCallback? onTap;

  final ValueChanged<bool>? onCompleted;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HabitIcon(
              icon: habit.icon,
              color: habit.color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: text.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.subtitle,
                    style: text.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  HabitFooter(
                    streak: habit.streak,
                    points: habit.points,
                  ),
                ],
              ),
            ),
            Checkbox(
              value: habit.completed,
              onChanged: (value) {
                if (value != null) {
                  onCompleted?.call(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
