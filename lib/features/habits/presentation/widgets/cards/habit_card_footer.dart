import 'package:flutter/material.dart';

import '../actions/habit_popup_menu.dart';

class HabitCardFooter extends StatelessWidget {
  const HabitCardFooter({
    super.key,
    required this.xp,
    required this.durationMinutes,
    required this.onMenuSelected,
  });

  final int xp;
  final int durationMinutes;

  final ValueChanged<HabitMenuAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Icon(
          Icons.stars_rounded,
          color: Colors.amber,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          "$xp XP",
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(width: 20),
        const Icon(
          Icons.schedule_rounded,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          "$durationMinutes min",
          style: theme.textTheme.labelMedium,
        ),
        const Spacer(),
        HabitPopupMenu(
          onSelected: onMenuSelected,
        ),
      ],
    );
  }
}
