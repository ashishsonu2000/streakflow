import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/calendar_day_state.dart';

class CalendarDayTile extends ConsumerWidget {
  const CalendarDayTile({
    super.key,
    required this.day,
  });

  final CalendarDayState day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Color backgroundColor = Colors.transparent;

    if (day.isSelected) {
      backgroundColor = theme.colorScheme.primary;
    } else if (!day.isCurrentMonth) {
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
    }

    Color textColor;

    if (day.isSelected) {
      textColor = theme.colorScheme.onPrimary;
    } else if (!day.isCurrentMonth) {
      textColor = theme.colorScheme.outline;
    } else {
      textColor = theme.colorScheme.onSurface;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: day.isToday
            ? Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            await ref.read(calendarProvider.notifier).selectDate(day.date);

            if (!context.mounted) return;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => DayDetailsSheet(
                date: day.date,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 6,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                if (day.totalHabits > 0)
                  Text(
                    '${day.completedHabits}/${day.totalHabits}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: textColor.withValues(alpha: 0.75),
                    ),
                  ),
                const SizedBox(height: 4),
                HeatmapIndicator(
                  intensity: day.intensity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
