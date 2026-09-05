import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../habits/domain/models/habit_log.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';

class StatisticsActivitySection
    extends StatelessWidget {
  const StatisticsActivitySection({
    super.key,
    required this.logs,
  });

  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    final recentLogs =
    logs.reversed.take(5).toList();

    return AppSectionCard(
      title: 'Recent Activity',
      child: recentLogs.isEmpty
          ? const _EmptyActivity()
          : Column(
        children: List.generate(
          recentLogs.length,
              (index) {
            final log =
            recentLogs[index];

            return _ActivityTile(
              log: log,
              showDivider:
              index <
                  recentLogs.length - 1,
            );
          },
        ),
      ),
    );
  }
}

// =====================================================================
// ACTIVITY TILE
// =====================================================================

class _ActivityTile
    extends StatelessWidget {
  const _ActivityTile({
    required this.log,
    required this.showDivider,
  });

  final HabitLog log;
  final bool showDivider;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final completed =
        log.completedAt != null;

    // ===============================================================
    // STATUS COLORS
    // ===============================================================

    final statusColor = completed
        ? const Color(0xFF22C55E)
        : colors.onSurfaceVariant;

    final statusBackground = completed
        ? const Color(0xFFECFDF5)
        : isDark
        ? colors.surfaceContainerHighest
        : const Color(0xFFF1F5F9);

    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            children: [
              // =======================================================
              // STATUS ICON
              // =======================================================

              Container(
                width: 38,
                height: 38,
                decoration:
                BoxDecoration(
                  color:
                  statusBackground,
                  shape:
                  BoxShape.circle,
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : Icons.remove_rounded,
                  size: 19,
                  color:
                  statusColor,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =======================================================
              // DATE / STATUS
              // =======================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(
                        log.date,
                      ),
                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color:
                        colors.onSurface,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      completed
                          ? 'Completed'
                          : 'Missed',
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: completed
                            ? const Color(
                          0xFF22C55E,
                        )
                            : colors
                            .onSurfaceVariant,
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // =======================================================
              // XP
              // =======================================================

              if (log.xpEarned > 0)
                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration:
                  BoxDecoration(
                    color: isDark
                        ? const Color(
                      0xFF7C2D12,
                    ).withValues(
                      alpha: 0.25,
                    )
                        : const Color(
                      0xFFFFF7ED,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      999,
                    ),
                    border: isDark
                        ? Border.all(
                      color:
                      const Color(
                        0xFFF59E0B,
                      ).withValues(
                        alpha: 0.18,
                      ),
                    )
                        : null,
                  ),
                  child: Text(
                    '+${log.xpEarned} XP',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      const Color(
                        0xFFF59E0B,
                      ),
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // =============================================================
        // DIVIDER
        // =============================================================

        if (showDivider)
          Divider(
            height: 1,
            color:
            colors.outlineVariant,
          ),
      ],
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _EmptyActivity
    extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        children: [
          // ===========================================================
          // ICON
          // ===========================================================

          Container(
            width: 48,
            height: 48,
            decoration:
            BoxDecoration(
              color:
              colors.primary
                  .withValues(
                alpha:
                theme.brightness ==
                    Brightness.dark
                    ? 0.16
                    : 0.08,
              ),
              shape:
              BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded,
              color:
              colors.primary,
              size: 24,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // ===========================================================
          // TITLE
          // ===========================================================

          Text(
            'No activity yet',
            style: theme
                .textTheme
                .titleSmall
                ?.copyWith(
              color:
              colors.onSurface,
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          // ===========================================================
          // DESCRIPTION
          // ===========================================================

          Text(
            'Complete a habit to see it here.',
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}