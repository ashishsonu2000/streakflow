import 'package:flutter/material.dart';

// =====================================================================
// PROGRESS ROW
// =====================================================================

class HabitStatsProgressRow extends StatelessWidget {
  const HabitStatsProgressRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final safeValue = value.isFinite
        ? value.clamp(0.0, 100.0)
        : 0.0;

    final progress =
        safeValue.toDouble() / 100.0;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: colors.onSurface,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            Text(
              '${safeValue.toStringAsFixed(1)}%',
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colors.primary,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius:
          BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor:
            colors.surfaceContainerHighest,
            valueColor:
            AlwaysStoppedAnimation<Color>(
              colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
