import 'package:flutter/material.dart';

import '../../domain/models/statistics_summary.dart';

class StatisticsSummaryCards extends StatelessWidget {
  final StatisticsSummary statistics;

  const StatisticsSummaryCards({
    super.key,
    required this.statistics,
  });

  Widget _card(
    IconData icon,
    String title,
    String value,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card(
          Icons.local_fire_department,
          "Current",
          "${statistics.currentStreak}",
        ),
        const SizedBox(width: 12),
        _card(
          Icons.star,
          "XP",
          "${statistics.totalXP}",
        ),
      ],
    );
  }
}
