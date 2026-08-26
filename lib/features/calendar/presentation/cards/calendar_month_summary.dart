import 'package:flutter/material.dart';

import '../../domain/models/calendar_view_model.dart';

class CalendarMonthSummary extends StatelessWidget {
  const CalendarMonthSummary({
    super.key,
    required this.calendar,
  });

  final CalendarViewModel calendar;

  @override
  Widget build(BuildContext context) {
    final monthDays = calendar.days
        .where(
          (day) => day.isCurrentMonth,
    )
        .toList();

    final completedDays = monthDays
        .where(
          (day) => day.hasActivity,
    )
        .length;

    final completedHabits = monthDays.fold<int>(
      0,
          (sum, day) => sum + day.completedHabits,
    );

    final totalPossibleCompletions =
    monthDays.fold<int>(
      0,
          (sum, day) => sum + day.totalHabits,
    );

    final completionRate =
    totalPossibleCompletions == 0
        ? 0.0
        : completedHabits /
        totalPossibleCompletions;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              icon:
              Icons.check_circle_outline_rounded,
              value: '$completedDays',
              label: 'Active days',
              accent:
              const Color(0xFF2563EB),
              iconBackground:
              const Color(0xFFEFF6FF),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _SummaryCard(
              icon: Icons.task_alt_rounded,
              value:
              '$completedHabits / '
                  '$totalPossibleCompletions',
              label: 'Completions',
              accent:
              const Color(0xFF16A34A),
              iconBackground:
              const Color(0xFFECFDF5),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _SummaryCard(
              icon: Icons.insights_rounded,
              value:
              '${(completionRate * 100).round()}%',
              label: 'Completion',
              accent:
              const Color(0xFF7C3AED),
              iconBackground:
              const Color(0xFFF3E8FF),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// SUMMARY CARD
// ===================================================================

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    required this.iconBackground,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 88,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD7E3F1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172554)
                .withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          // =========================================================
          // ICON
          // =========================================================

          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withValues(
                  alpha: 0.12,
                ),
              ),
            ),
            child: Icon(
              icon,
              size: 17,
              color: accent,
            ),
          ),

          const SizedBox(height: 5),

          // =========================================================
          // VALUE
          // =========================================================

          Text(
            value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 2),

          // =========================================================
          // LABEL
          // =========================================================

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
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}