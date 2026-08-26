import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';
import '../../../domain/models/monthly_statistics.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({
    super.key,
    required this.monthly,
  });

  final MonthlyStatistics monthly;

  @override
  Widget build(BuildContext context) {
    final completion =
    (monthly.monthlyCompletionRate * 100)
        .round();

    return AppSectionCard(
      title: 'This Month',
      child: Column(
        children: [
          // =========================================================
          // COMPLETION / PERFECT DAYS
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Completion',
                  value: '$completion%',
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
              Expanded(
                child: _Metric(
                  title: 'Perfect Days',
                  value:
                  '${monthly.perfectDays}',
                  valueColor:
                  const Color(0xFF16A34A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================================================
          // COMPLETED / XP
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Completed',
                  value:
                  '${monthly.totalCompleted}',
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
              Expanded(
                child: _Metric(
                  title: 'XP',
                  value:
                  '${monthly.totalXP}',
                  valueColor:
                  const Color(0xFFD97706),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================================================
          // DURATION
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: 'Duration',
                  value:
                  '${monthly.totalDurationMinutes} min',
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// METRIC
// ===================================================================

class _Metric extends StatelessWidget {
  const _Metric({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ??
                  const Color(0xFF0F172A),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}