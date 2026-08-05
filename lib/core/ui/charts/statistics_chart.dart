import 'package:flutter/material.dart';

import '../../../../shared/ui/cards/app_section_card.dart';

import 'chart_point.dart';
import 'chart_theme.dart';
import 'statistics_line_chart.dart';

class StatisticsChart extends StatelessWidget {
  const StatisticsChart({
    super.key,
    required this.title,
    required this.points,
  });

  final String title;
  final List<ChartPoint> points;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: title,
      child: SizedBox(
        height: ChartTheme.chartHeight,
        width: double.infinity,
        child: StatisticsLineChart(
          points: points,
        ),
      ),
    );
  }
}
