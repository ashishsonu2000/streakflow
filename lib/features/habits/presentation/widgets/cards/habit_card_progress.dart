import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/habit.dart';
import '../../../domain/models/habit_schedule_status.dart';

class HabitCardProgress extends StatelessWidget {
  const HabitCardProgress({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final status = habit.scheduleStatus;

    final progress =
    habit.completedToday ? 1.0 : 0.0;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // =============================================================
        // DATE RANGE
        // =============================================================

        _HabitDateRange(
          habit: habit,
        ),

        const SizedBox(
          height: 9,
        ),

        // =============================================================
        // UPCOMING
        // =============================================================

        if (status ==
            HabitScheduleStatus.upcoming)
          _StatusMessage(
            icon: Icons.schedule_outlined,
            text: 'Habit has not started yet.',
            color: colors.primary,
          )

        // =============================================================
        // EXPIRED
        // =============================================================

        else if (status ==
            HabitScheduleStatus.expired)
          _StatusMessage(
            icon: Icons.event_available_outlined,
            text: 'Habit period has ended.',
            color: colors.onSurfaceVariant,
          )

        // =============================================================
        // ACTIVE
        // =============================================================

        else ...[
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Progress",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(
                999,
              ),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor:
                colors.onSurface.withValues(
                  alpha: theme.brightness ==
                      Brightness.dark
                      ? 0.10
                      : 0.08,
                ),
                valueColor:
                AlwaysStoppedAnimation<Color>(
                  colors.primary,
                ),
              ),
            ),
          ],
      ],
    );
  }
}

// =====================================================================
// DATE RANGE
// =====================================================================

class _HabitDateRange extends StatelessWidget {
  const _HabitDateRange({
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final start = DateFormat(
      'dd MMM yyyy',
    ).format(
      habit.startDate,
    );

    final String text;

    if (habit.endDate == null) {
      text = 'Started $start • Ongoing';
    } else {
      final end = DateFormat(
        'dd MMM yyyy',
      ).format(
        habit.endDate!,
      );

      text = '$start → $end';
    }

    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// STATUS MESSAGE
// =====================================================================

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}