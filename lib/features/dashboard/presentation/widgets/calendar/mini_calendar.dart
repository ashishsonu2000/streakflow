import 'package:flutter/material.dart';

import '../../../../../core/ui/section/app_section_header.dart';
import '../../../../../core/ui/theme/app_spacing.dart';
import '../../../../calendar/domain/models/calendar_view_model.dart';

import 'calendar_grid.dart';
import 'calendar_legend.dart';
import 'calendar_weekdays.dart';

class MiniCalendar extends StatelessWidget {
  const MiniCalendar({
    super.key,
    required this.calendar,
    this.onTap,
  });

  final CalendarViewModel calendar;

  /// Called when either the View button or a day is tapped.
  final ValueChanged<DateTime>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // =========================================================
        // CARD SURFACE
        // =========================================================

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FAFC),
            Color(0xFFEEF4FA),
          ],
        ),

        borderRadius: BorderRadius.circular(22),

        // =========================================================
        // BLUE / NAVY BORDER
        // =========================================================

        border: Border.all(
          color: const Color(0xFF2563EB).withValues(
            alpha: 0.24,
          ),
          width: 1.2,
        ),

        // =========================================================
        // SUBTLE SHADOW
        // =========================================================

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(
              alpha: 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          16,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =======================================================
            // HEADER
            // =======================================================

            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    size: 21,
                    color: Color(0xFF2563EB),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: AppSectionHeader(
                    title: 'Calendar',
                    subtitle: calendar.monthName,
                    actionText: 'View',
                    onAction: onTap == null
                        ? null
                        : () {
                      onTap!(
                        calendar.selectedDate,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            // =======================================================
            // WEEKDAYS
            // =======================================================

            const CalendarWeekdays(),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            // =======================================================
            // CALENDAR GRID
            // =======================================================

            CalendarGrid(
              days: calendar.days,
              onDayTap: (day) {
                onTap?.call(day.date);
              },
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            // =======================================================
            // LEGEND
            // =======================================================

            const CalendarLegend(),
          ],
        ),
      ),
    );
  }
}