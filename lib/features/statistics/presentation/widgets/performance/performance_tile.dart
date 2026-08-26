import 'package:flutter/material.dart';

import '../../../domain/models/habit_performance.dart';

class PerformanceTile extends StatelessWidget {
  const PerformanceTile({
    super.key,
    required this.performance,
  });

  final HabitPerformance performance;

  @override
  Widget build(BuildContext context) {
    final completion =
    (performance.completionRate * 100)
        .clamp(0, 100);

    final isComplete =
        performance.completionRate >= 1.0;

    final progressColor = isComplete
        ? const Color(0xFF16A34A)
        : const Color(0xFF2563EB);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFE),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD7E3F1),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =========================================================
          // HEADER
          // =========================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  performance.title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFEFF6FF),
                  borderRadius:
                  BorderRadius.circular(999),
                ),
                child: Text(
                  '${completion.round()}%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =========================================================
          // PROGRESS
          // =========================================================

          ClipRRect(
            borderRadius:
            BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: performance.completionRate
                  .clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor:
              const Color(0xFFE2E8F0),
              valueColor:
              AlwaysStoppedAnimation<Color>(
                progressColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // =========================================================
          // METRICS
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Completed',
                  value:
                  '${performance.totalCompleted}',
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Current',
                  value:
                  '${performance.currentStreak}',
                  valueColor:
                  const Color(0xFFEA580C),
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Best',
                  value:
                  '${performance.bestStreak}',
                  valueColor:
                  const Color(0xFF16A34A),
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'XP',
                  value:
                  '${performance.totalXP}',
                  valueColor:
                  const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// METRIC
// =====================================================================

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor ??
                const Color(0xFF0F172A),
            fontSize: 14,
            fontWeight:
            FontWeight.w700,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}