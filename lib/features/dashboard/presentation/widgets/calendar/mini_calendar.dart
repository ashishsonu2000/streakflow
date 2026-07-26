import 'package:flutter/material.dart';

import '../../../../../core/ui/section/app_section_header.dart';
import '../../../../../core/ui/theme/app_spacing.dart';
import '../../../../../shared/ui/cards/app_card.dart';
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------------------------------------
          // Section Header
          //------------------------------------------------------

          AppSectionHeader(
            title: "Calendar",
            subtitle: calendar.monthName,
            actionText: "View",
            onAction: onTap,
            padding: EdgeInsets.zero,
          ),

          const SizedBox(height: AppSpacing.lg),

          //------------------------------------------------------
          // Week Days
          //------------------------------------------------------

          const CalendarWeekdays(),

          const SizedBox(height: AppSpacing.sm),

          //------------------------------------------------------
          // Calendar Grid
          //------------------------------------------------------

          CalendarGrid(
            days: calendar.days,
            onDayTap: (day) {
              debugPrint(day.date.toString());
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          //------------------------------------------------------
          // Legend
          //------------------------------------------------------

          const CalendarLegend(),
        ],
      ),
    );
  }
}
