import 'package:flutter/material.dart';
import 'package:streak_calculator_flutter/core/ui/charts/statistics_chart.dart';

import '../../../features/habits/domain/models/analytics/habit_details_analytics.dart';
import 'chart_data_mapper.dart';
import 'chart_type.dart';

class WeeklyCompletionChart
    extends StatelessWidget {
  const WeeklyCompletionChart({
    super.key,
    required this.analytics,
  });

  final HabitDetailAnalytics analytics;

  @override
  Widget build(
      BuildContext context,
      ) {
    final points =
    const ChartDataMapper().map(
      trends: analytics.weeklyData,
      type: ChartType.weekly,
    );

    return StatisticsChart(
      title: 'Weekly Progress',
      points: points,
    );
  }
}