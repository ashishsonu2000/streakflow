import 'package:flutter/material.dart';

import '../../../../../core/ui/charts/chart_point.dart';
import '../../../../../core/ui/charts/statistics_chart.dart';

import 'weekly_summary_card.dart';

import '../../../domain/models/weekly_statistics.dart';

class WeeklySection extends StatelessWidget {
  const WeeklySection({
    super.key,
    required this.weekly,
    required this.chartPoints,
  });

  final WeeklyStatistics weekly;

  final List<ChartPoint> chartPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------------------
        // Summary
        //------------------------------------------

        WeeklySummaryCard(
          weekly: weekly,
        ),

        const SizedBox(height: 24),

        //------------------------------------------
        // Trend Chart
        //------------------------------------------

        StatisticsChart(
          title: 'Weekly Progress',
          points: chartPoints,
        ),
      ],
    );
  }
}
