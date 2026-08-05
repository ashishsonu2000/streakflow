import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_card.dart';
import '../../../../../../core/ui/section/app_section_header.dart';

import '../../../domain/models/habit_performance.dart';

import 'performance_tile.dart';

class PerformanceSection extends StatelessWidget {
  const PerformanceSection({
    super.key,
    required this.performance,
  });

  final List<HabitPerformance> performance;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Habit Performance',
          ),
          const SizedBox(height: 16),
          if (performance.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No performance data available.',
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: performance.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return PerformanceTile(
                  performance: performance[index],
                );
              },
            ),
        ],
      ),
    );
  }
}
