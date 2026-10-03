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
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    if (points.isEmpty) {
      return Center(
        child: Text(
          'No chart data available',

          style: theme
              .textTheme
              .bodySmall
              ?.copyWith(
            color:
            colors.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      );
    }

    final primaryColor =
        colors.primary;

    final maxValue =
    points.fold<double>(
      0,
          (
          maximum,
          point,
          ) =>
      point.value > maximum
          ? point.value
          : maximum,
    );

    final chartMaxY =
    _maxY(maxValue);

    final horizontalInterval =
    _horizontalInterval(
      chartMaxY,
    );

    // ===============================================================
    // THEME COLORS
    // ===============================================================

    final gridColor = isDark
        ? colors.outlineVariant
        .withValues(
      alpha: 0.45,
    )
        : const Color(
      0xFFE2E8F0,
    );

    final axisTextColor = isDark
        ? colors.onSurfaceVariant
        : const Color(
      0xFF64748B,
    );

    final tooltipBackground =
    isDark
        ? colors
        .surfaceContainerHighest
        : const Color(
      0xFF0F172A,
    );

    final tooltipTextColor =
    isDark
        ? colors.onSurface
        : Colors.white;

    final dotBackground =
    isDark
        ? colors
        .surfaceContainerHighest
        : Colors.white;

    return LineChart(
      LineChartData(
        minY: 0,

        maxY: chartMaxY,

        // =========================================================
        // GRID
        // =========================================================

        gridData:
        FlGridData(
          show: true,

          drawVerticalLine:
          false,

          horizontalInterval:
          horizontalInterval,

          getDrawingHorizontalLine:
              (value) {
            return FlLine(
              color:
              gridColor,
              strokeWidth: 1,
            );
          },
        ),

        // =========================================================
        // BORDER
        // =========================================================

        borderData:
        FlBorderData(
          show: false,
        ),

        // =========================================================
        // TITLES
        // =========================================================

        titlesData:
        FlTitlesData(
          rightTitles:
          const AxisTitles(),

          topTitles:
          const AxisTitles(),

          // =======================================================
          // LEFT AXIS
          // =======================================================

          leftTitles:
          AxisTitles(
            sideTitles:
            SideTitles(
              showTitles:
              true,

              reservedSize:
              32,

              interval:
              horizontalInterval,

              getTitlesWidget:
                  (
                  value,
                  meta,
                  ) {
                return Text(
                  _formatNumber(
                    value,
                  ),

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    axisTextColor,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w500,
                  ),
                );
              },
            ),
          ),

          // =======================================================
          // BOTTOM AXIS
          // =======================================================

          bottomTitles:
          AxisTitles(
            sideTitles:
            SideTitles(
              showTitles:
              true,

              reservedSize:
              30,

              interval:
              _xAxisInterval(
                points.length,
              ),

              getTitlesWidget:
                  (
                  value,
                  meta,
                  ) {
                final index =
                value.round();

                if (index < 0 ||
                    index >=
                        points.length) {
                  return const SizedBox
                      .shrink();
                }

                if (!_shouldShowLabel(
                  index,
                  points.length,
                )) {
                  return const SizedBox
                      .shrink();
                }

                return SideTitleWidget(
                  meta: meta,

                  space: 8,

                  child: Text(
                    points[index]
                        .label,

                    maxLines: 1,

                    overflow:
                    TextOverflow
                        .ellipsis,

                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      axisTextColor,
                      fontSize: 10,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // =========================================================
        // TOUCH / TOOLTIP
        // =========================================================

        lineTouchData:
        LineTouchData(
          enabled: true,

          handleBuiltInTouches:
          true,

          touchTooltipData:
          LineTouchTooltipData(
            getTooltipColor:
                (_) =>
            tooltipBackground,

            getTooltipItems:
                (touchedSpots) {
              return touchedSpots
                  .map(
                    (spot) {
                  final index =
                  spot.x.round();

                  if (index < 0 ||
                      index >=
                          points.length) {
                    return null;
                  }

                  return LineTooltipItem(
                    '${points[index].label}\n'
                        '${_formatNumber(spot.y)}',

                    TextStyle(
                      color:
                      tooltipTextColor,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  );
                },
              )
                  .whereType<
                  LineTooltipItem>()
                  .toList();
            },
          ),
        ),

        // =========================================================
        // LINE
        // =========================================================

        lineBarsData: [
          LineChartBarData(
            isCurved:
            true,

            curveSmoothness:
            0.25,

            color:
            primaryColor,

            barWidth:
            ChartTheme
                .strokeWidth,

            isStrokeCapRound:
            true,

            isStrokeJoinRound:
            true,

            // =====================================================
            // AREA
            // =====================================================

            belowBarData:
            BarAreaData(
              show: true,

              color:
              primaryColor
                  .withValues(
                alpha:
                isDark
                    ? 0.12
                    : 0.08,
              ),
            ),

            // =====================================================
            // DOTS
            // =====================================================

            dotData:
            FlDotData(
              show:
              points.length <=
                  14,

              getDotPainter:
                  (
                  spot,
                  percent,
                  bar,
                  index,
                  ) {
                return FlDotCirclePainter(
                  radius:
                  3.5,

                  color:
                  dotBackground,

                  strokeWidth:
                  2,

                  strokeColor:
                  primaryColor,
                );
              },
            ),

            // =====================================================
            // DATA POINTS
            // =====================================================

            spots:
            List.generate(
              points.length,
                  (index) {
                return FlSpot(
                  index
                      .toDouble(),
                  points[index]
                      .value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // X AXIS
  // =================================================================

  double _xAxisInterval(
      int count,
      ) {
    if (count <= 7) {
      return 1;
    }

    if (count <= 14) {
      return 2;
    }

    if (count <= 21) {
      return 3;
    }

    return 5;
  }

  bool _shouldShowLabel(
      int index,
      int count,
      ) {
    if (count <= 7) {
      return true;
    }

    if (count <= 14) {
      return index % 2 == 0 ||
          index == count - 1;
    }

    if (count <= 21) {
      return index % 3 == 0 ||
          index == count - 1;
    }

    return index % 5 == 0 ||
        index == count - 1;
  }

  // =================================================================
  // Y AXIS
  // =================================================================

  double _maxY(
      double maximum,
      ) {
    if (maximum <= 0) {
      return 10;
    }

    if (maximum <= 10) {
      return 10;
    }

    if (maximum <= 25) {
      return 25;
    }

    if (maximum <= 50) {
      return 50;
    }

    if (maximum <= 100) {
      return 100;
    }

    return (maximum / 20).ceil() * 20;
  }

  double _horizontalInterval(
      double maxY,
      ) {
    if (maxY <= 10) {
      return 2;
    }

    if (maxY <= 25) {
      return 5;
    }

    if (maxY <= 50) {
      return 10;
    }

    return 20;
  }

  String _formatNumber(
      double value,
      ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .toInt()
          .toString();
    }

    return value.toStringAsFixed(
      1,
    );
  }
}