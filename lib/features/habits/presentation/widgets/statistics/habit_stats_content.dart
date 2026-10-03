import 'package:flutter/material.dart';

import '../../../domain/models/habit_statistics.dart';
import 'habit_stats_month_view.dart';
import 'habit_stats_overview_view.dart';
import 'habit_stats_week_view.dart';
import 'habit_stats_year_view.dart';

// =====================================================================
// STATISTICS CONTENT
// =====================================================================

class HabitStatsContent extends StatelessWidget {
  const HabitStatsContent({
    super.key,
    required this.statistics,
    required this.selectedView,
    required this.selectedDate,
  });

  final HabitStatistics statistics;
  final int selectedView;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    switch (selectedView) {
      case 1:
        return HabitStatsWeekView(
          statistics: statistics,
        );

      case 2:
        return HabitStatsMonthView(
          statistics: statistics,
        );

      case 3:
        return HabitStatsYearView(
          statistics: statistics,
        );

      default:
        return HabitStatsOverviewView(
          statistics: statistics,
        );
    }
  }
}
