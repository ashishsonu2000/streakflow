import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'chart_point.dart';
import 'chart_theme.dart';

class StatisticsLineChart extends StatelessWidget {
  const StatisticsLineChart({
    super.key,
    required this.points,
  });

  final List<ChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return LineChart(
      LineChartData(
        minY: ChartTheme.minY,
        maxY: ChartTheme.maxY,
        gridData: const FlGridData(
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 20,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();

                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[index].label,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: color,
            barWidth: ChartTheme.strokeWidth,
            dotData: FlDotData(
              show: true,
            ),
            spots: List.generate(
              points.length,
              (index) => FlSpot(
                index.toDouble(),
                points[index].value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
