import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/calendar_day_view_model.dart';
import '../providers/calendar_provider.dart';
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

    //------------------------------------------------------
    // Background
    //------------------------------------------------------

    final Color background = switch ((day.isSelected, day.isCurrentMonth)) {
      (true, _) => theme.colorScheme.primary,
      (false, false) => theme.colorScheme.surfaceContainerHighest,
      _ => Colors.transparent,
    };

    //------------------------------------------------------
    // Foreground
    //------------------------------------------------------

    final Color foreground = switch ((day.isSelected, day.isCurrentMonth)) {
      (true, _) => theme.colorScheme.onPrimary,
      (false, false) => theme.colorScheme.outline,
      _ => theme.colorScheme.onSurface,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await ref.read(calendarProvider.notifier).selectDate(day.date);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: day.isToday
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //--------------------------------------------------
                // Day Number
                //--------------------------------------------------

                Text(
                  '${day.date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                //--------------------------------------------------
                // Heatmap Indicator
                //--------------------------------------------------

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
