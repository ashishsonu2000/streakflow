import 'package:flutter/material.dart';

import '../../domain/models/statistics_summary.dart';

class StatisticsProgressCard extends StatelessWidget {
  final StatisticsSummary statistics;

  const StatisticsProgressCard({
    super.key,
    required this.statistics,
  });

  Widget _progress(
    String title,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 10,
          ),
          const SizedBox(height: 8),
          Text("${(value * 100).round()}%"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = statistics.dashboard;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _progress(
              "Today",
              dashboard.progress,
            ),
            _progress(
              "Week",
              dashboard.weeklyCompletion / 100,
            ),
            _progress(
              "Month",
              dashboard.monthlyCompletion / 100,
            ),
          ],
        ),
      ),
    );
  }
}
