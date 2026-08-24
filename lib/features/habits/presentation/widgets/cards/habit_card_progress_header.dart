import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/ui/progress/animated_linear_progress.dart';
import '../../../../../core/ui/progress/app_progress_header.dart';
import '../../../../../core/ui/spacing/app_spacing.dart';
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

    final status = habit.scheduleStatus;

    final progress =
    habit.completedToday ? 1.0 : 0.0;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _HabitDateRange(
          habit: habit,
        ),

        const Gap.vertical(
          AppSpacing.sm,
        ),

        // =====================================================
        // Upcoming
        // =====================================================

        if (status ==
            HabitScheduleStatus.upcoming)
          _StatusMessage(
            icon: Icons.schedule_outlined,
            text: 'Habit has not started yet.',
            color:
            theme.colorScheme.primary,
          )

        // =====================================================
        // Expired
        // =====================================================

        else if (status ==
            HabitScheduleStatus.expired)
          _StatusMessage(
            icon: Icons.event_available_outlined,
            text: 'Habit period has ended.',
            color:
            theme.colorScheme.onSurfaceVariant,
          )

        // =====================================================
        // Active
        // =====================================================

        else ...[
            AppProgressHeader(
              label: "Today's Progress",
              progress: progress,
            ),

            const Gap.vertical(
              AppSpacing.sm,
            ),

            AnimatedLinearProgress(
              progress: progress,
            ),
          ],
      ],
    );
  }
}

// =============================================================
// Date Range
// =============================================================

class _HabitDateRange extends StatelessWidget {
  const _HabitDateRange({
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final start =
    DateFormat('dd MMM yyyy')
        .format(habit.startDate);

    final String text;

    if (habit.endDate == null) {
      text =
      'Started $start • Ongoing';
    } else {
      final end =
      DateFormat('dd MMM yyyy')
          .format(habit.endDate!);

      text =
      '$start → $end';
    }

    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color:
          theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style:
            theme.textTheme.bodySmall?.copyWith(
              color:
              theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// Status Message
// =============================================================

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
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style:
          theme.textTheme.bodySmall?.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}