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
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    const blue = Color(0xFF2563EB);

    // =============================================================
    // BACKGROUND
    // =============================================================

    final Color background =
    switch ((day.isSelected, day.isCurrentMonth)) {
    // -----------------------------------------------------------
    // Selected date
    // -----------------------------------------------------------

      (true, _) => blue,

    // -----------------------------------------------------------
    // Days outside current month
    // -----------------------------------------------------------

      (false, false) => isDark
          ? colors.surfaceContainerHighest.withValues(
        alpha: 0.70,
      )
          : const Color(0xFFE2E8F0),

    // -----------------------------------------------------------
    // Normal current-month day
    // -----------------------------------------------------------

      _ => Colors.transparent,
    };

    // =============================================================
    // FOREGROUND
    // =============================================================

    final Color foreground =
    switch ((day.isSelected, day.isCurrentMonth)) {
    // -----------------------------------------------------------
    // Selected date
    // -----------------------------------------------------------

      (true, _) => Colors.white,

    // -----------------------------------------------------------
    // Outside current month
    // -----------------------------------------------------------

      (false, false) => isDark
          ? colors.onSurfaceVariant.withValues(
        alpha: 0.65,
      )
          : const Color(0xFF94A3B8),

    // -----------------------------------------------------------
    // Current month
    // -----------------------------------------------------------

      _ => colors.onSurface,
    };

    // =============================================================
    // TODAY BORDER
    // =============================================================

    final Color todayBorder =
    day.isSelected
        ? Colors.white
        : colors.primary;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius:
        BorderRadius.circular(12),

        onTap: () async {
          await ref
              .read(
            calendarProvider.notifier,
          )
              .selectDate(
            day.date,
          );
        },

        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 180,
          ),

          curve:
          Curves.easeOutCubic,

          margin:
          const EdgeInsets.all(1),

          decoration: BoxDecoration(
            color: background,

            borderRadius:
            BorderRadius.circular(12),

            // =====================================================
            // TODAY BORDER
            // =====================================================

            border: day.isToday
                ? Border.all(
              color: todayBorder,
              width: 1.5,
            )
                : null,
          ),

          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 4,
            ),

            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              mainAxisSize:
              MainAxisSize.min,

              children: [
                // =================================================
                // DAY NUMBER
                // =================================================

                Text(
                  '${day.date.day}',

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: foreground,

                    fontWeight:
                    day.isToday ||
                        day.isSelected
                        ? FontWeight.w800
                        : FontWeight.w600,

                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                // =================================================
                // ACTIVITY INDICATOR
                // =================================================

                HeatmapIndicator(
                  intensity:
                  day.intensity,

                  size:
                  day.hasActivity
                      ? 7
                      : 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}