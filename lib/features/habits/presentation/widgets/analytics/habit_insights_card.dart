import 'package:flutter/material.dart';

import '../../../domain/models/habit.dart';
import '../../../domain/services/habit_insight_service.dart';

class HabitInsightsCard
    extends StatelessWidget {
  const HabitInsightsCard({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(
      BuildContext context,
      ) {
    final insights =
    const HabitInsightService()
        .generate(
      habit,
    );

    if (insights.isEmpty) {
      return const SizedBox();
    }

    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Insights',
              style: Theme.of(
                context,
              ).textTheme.titleMedium,
            ),

            const SizedBox(
              height: 16,
            ),

            ...insights.map(
                  (insight) => Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 12,
                ),
                child: Text(
                  '${insight.icon} ${insight.message}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}