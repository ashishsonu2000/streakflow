import 'package:flutter/material.dart';

class TodayHabitEmpty extends StatelessWidget {
  const TodayHabitEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 36,
        horizontal: 16,
      ),
      child: Column(
        children: [
          // =============================================================
          // ICON
          // =============================================================

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration_rounded,
              size: 30,
              color: primary,
            ),
          ),

          const SizedBox(height: 16),

          // =============================================================
          // TITLE
          // =============================================================

          Text(
            "You're all caught up!",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          // =============================================================
          // DESCRIPTION
          // =============================================================

          Text(
            "Great job! You've completed all your habits for today.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // =============================================================
          // SUCCESS INDICATOR
          // =============================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 6),
                Text(
                  'Daily goal complete',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}