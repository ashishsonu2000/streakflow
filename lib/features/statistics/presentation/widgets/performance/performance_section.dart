import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';

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
    return AppSectionCard(
      title: 'Habit Performance',
      child: performance.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No performance data available.',
                ),
              ),
            )
          : ListView.separated(
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
    );
  }
}
