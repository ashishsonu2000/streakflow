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
        // =========================================================
        // STREAK
        // =========================================================

        Expanded(
          child: _StatusPill(
            icon: Icons.local_fire_department_rounded,
            label:
            '${habit.currentStreak} '
                'Day${habit.currentStreak == 1 ? '' : 's'}',
            backgroundColor:
            const Color(0xFFFFF7ED),
            foregroundColor:
            const Color(0xFFEA580C),
          ),
        ),

        const SizedBox(width: 10),

        // =========================================================
        // COMPLETION STATUS
        // =========================================================

        Expanded(
          child: _StatusPill(
            icon: completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            label: completed
                ? 'Completed'
                : 'Pending',
            backgroundColor: completed
                ? const Color(0xFFECFDF5)
                : const Color(0xFFF1F5F9),
            foregroundColor: completed
                ? const Color(0xFF16A34A)
                : const Color(0xFF64748B),
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
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: foregroundColor,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 12,
                fontWeight:
                FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}