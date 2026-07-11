import 'package:flutter/material.dart';

import '../../domain/models/habit_detail.dart';
import '../widgets/statistic_card.dart';

class DetailStatisticsSection extends StatelessWidget {
  const DetailStatisticsSection({
    super.key,
    required this.detail,
  });

  final HabitDetail detail;

  @override
  Widget build(BuildContext context) {
    final stats = detail.statistics;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Statistics",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (_, index) {
                return StatisticCard(
                  stat: stats[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
