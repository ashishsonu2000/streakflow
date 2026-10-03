import 'package:flutter/material.dart';
import 'package:streak_calculator_flutter/core/ui/charts/statistics_chart.dart';

import '../../../features/habits/domain/models/analytics/habit_details_analytics.dart';
import 'chart_data_mapper.dart';
import 'chart_type.dart';

class MonthlyCompletionChart
    extends StatelessWidget {
  const MonthlyCompletionChart({
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
      trends: analytics.monthlyData,
      type: ChartType.monthly,
    );

    return StatisticsChart(
      title: 'Monthly Progress',
      points: points,
    );
  }
}