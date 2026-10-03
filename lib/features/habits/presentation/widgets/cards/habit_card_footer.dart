import 'package:flutter/material.dart';

import '../../../domain/models/habit.dart';

class HabitCardFooter extends StatelessWidget {
  const HabitCardFooter({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final completed = habit.completedToday;

    return Row(
      children: [
        Expanded(
          child: _StatusPill(
            icon:
            Icons.local_fire_department_rounded,
            label:
            '${habit.currentStreak} '
                'Day${habit.currentStreak == 1 ? '' : 's'}',
            accentColor:
            const Color(0xFFF97316),
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: _StatusPill(
            icon: completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            label: completed
                ? 'Completed'
                : 'Pending',
            accentColor: completed
                ? const Color(0xFF22C55E)
                : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// STATUS PILL
// =====================================================================

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    final backgroundColor = accentColor.withValues(
      alpha: isDark ? 0.10 : 0.08,
    );

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(999),
        border: Border.all(
          color: accentColor.withValues(
            alpha: isDark ? 0.20 : 0.10,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: accentColor,
          ),

          const SizedBox(
            width: 6,
          ),

          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}