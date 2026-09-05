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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    final completion =
    (performance.completionRate * 100)
        .clamp(0, 100);

    final isComplete =
        performance.completionRate >= 1.0;

    final progressColor = isComplete
        ? const Color(0xFF22C55E)
        : const Color(0xFF3B82F6);

    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        // ===========================================================
        // THEME-AWARE CARD
        // ===========================================================

        color: isDark
            ? colors.surfaceContainerHighest
            : const Color(0xFFF9FBFE),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: isDark
              ? colors.outlineVariant
              : const Color(0xFFD7E3F1),
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
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color:
                    colors.onSurface,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =====================================================
              // COMPLETION BADGE
              // =====================================================

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),

                decoration:
                BoxDecoration(
                  color: isComplete
                      ? const Color(
                    0xFF16A34A,
                  ).withValues(
                    alpha:
                    isDark
                        ? 0.18
                        : 0.08,
                  )
                      : colors.primary
                      .withValues(
                    alpha:
                    isDark
                        ? 0.18
                        : 0.08,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    999,
                  ),
                ),

                child: Text(
                  '${completion.round()}%',

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    progressColor,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          // =========================================================
          // PROGRESS
          // =========================================================

          ClipRRect(
            borderRadius:
            BorderRadius.circular(999),

            child:
            LinearProgressIndicator(
              value:
              performance
                  .completionRate
                  .clamp(
                0.0,
                1.0,
              ),

              minHeight: 8,

              backgroundColor:
              isDark
                  ? colors
                  .surfaceContainerHighest
                  : const Color(
                0xFFE2E8F0,
              ),

              valueColor:
              AlwaysStoppedAnimation<
                  Color>(
                progressColor,
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

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
                  const Color(
                    0xFFF97316,
                  ),
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Best',
                  value:
                  '${performance.bestStreak}',
                  valueColor:
                  const Color(
                    0xFF22C55E,
                  ),
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'XP',
                  value:
                  '${performance.totalXP}',
                  valueColor:
                  const Color(
                    0xFFF59E0B,
                  ),
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
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Column(
      children: [
        // =============================================================
        // VALUE
        // =============================================================

        Text(
          value,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,

          style: theme
              .textTheme
              .titleSmall
              ?.copyWith(
            color:
            valueColor ??
                colors.onSurface,
            fontSize: 14,
            fontWeight:
            FontWeight.w700,
            height: 1.1,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        // =============================================================
        // LABEL
        // =============================================================

        Text(
          label,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          textAlign:
          TextAlign.center,

          style: theme
              .textTheme
              .bodySmall
              ?.copyWith(
            color:
            colors.onSurfaceVariant,
            fontSize: 10,
            fontWeight:
            FontWeight.w500,
          ),
        ),
      ],
    );
  }
}