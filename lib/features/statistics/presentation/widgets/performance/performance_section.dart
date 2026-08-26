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
          ? const _EmptyPerformance()
          : Column(
        children: List.generate(
          performance.length,
              (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index ==
                    performance.length - 1
                    ? 0
                    : 12,
              ),
              child: PerformanceTile(
                performance:
                performance[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _EmptyPerformance
    extends StatelessWidget {
  const _EmptyPerformance();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_rounded,
              size: 24,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'No performance data yet',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Complete some habits to see your performance.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}