import 'package:flutter/material.dart';

import '../../../domain/models/habit_log.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.log,
  });

  final HabitLog log;

  String _relativeDate() {
    final now = DateTime.now();

    final difference =
        DateTime(
          now.year,
          now.month,
          now.day,
        ).difference(
          DateTime(
            log.date.year,
            log.date.month,
            log.date.day,
          ),
        ).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    if (difference > 1) {
      return '$difference days ago';
    }

    return 'Upcoming';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completed = log.completedAt != null;

    const blue = Color(0xFF2563EB);
    const navy = Color(0xFF0F172A);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFFEAF1F8)
            : const Color(0xFFF8FAFC),
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: blue.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          // =========================================================
          // STATUS
          // =========================================================

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: completed
                  ? blue.withValues(
                alpha: 0.10,
              )
                  : theme
                  .colorScheme
                  .surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.check_rounded
                  : Icons.close_rounded,
              size: 20,
              color: completed
                  ? blue
                  : theme.colorScheme.outline,
            ),
          ),

          const SizedBox(width: 11),

          // =========================================================
          // ACTIVITY
          // =========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  completed
                      ? 'Completed'
                      : 'Missed',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color: navy,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _relativeDate(),
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // =========================================================
          // XP
          // =========================================================

          if (log.xpEarned > 0)
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                borderRadius:
                BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    size: 13,
                    color: Color(0xFFD97706),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '+${log.xpEarned}',
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(width: 8),

          // =========================================================
          // TIME
          // =========================================================

          Text(
            log.completedAt == null
                ? '--'
                : TimeOfDay.fromDateTime(
              log.completedAt!,
            ).format(context),
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color: const Color(0xFF64748B),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}