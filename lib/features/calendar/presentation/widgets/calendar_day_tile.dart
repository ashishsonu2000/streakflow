import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/calendar_day_view_model.dart';
import '../providers/calendar_provider.dart';
import 'day_details/day_details_sheet.dart';
import 'heatmap/heatmap_indicator.dart';

class CalendarDayTile extends ConsumerWidget {
  const CalendarDayTile({
    super.key,
    required this.day,
  });

  final CalendarDayViewModel day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final Color background = day.isSelected
        ? theme.colorScheme.primary
        : day.isCurrentMonth
            ? Colors.transparent
            : theme.colorScheme.surfaceContainerHighest;

    final Color foreground = day.isSelected
        ? theme.colorScheme.onPrimary
        : day.isCurrentMonth
            ? theme.colorScheme.onSurface
            : theme.colorScheme.outline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
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
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await ref.read(calendarProvider.notifier).selectDate(day.date);

            if (!context.mounted) return;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => DayDetailsSheet(
                day: day,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (day.totalHabits > 0)
                  Text(
                    '${day.completedHabits}/${day.totalHabits}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foreground.withValues(alpha: .75),
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
