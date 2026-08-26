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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.log,
    required this.showDivider,
  });

  final HabitLog log;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final completed =
        log.completedAt != null;

    final statusColor = completed
        ? const Color(0xFF16A34A)
        : const Color(0xFF94A3B8);

    final statusBackground = completed
        ? const Color(0xFFECFDF5)
        : const Color(0xFFF1F5F9);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
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
                decoration: BoxDecoration(
                  color: statusBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : Icons.remove_rounded,
                  size: 19,
                  color: statusColor,
                ),
              ),

              const SizedBox(width: 12),

              // =======================================================
              // DATE
              // =======================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(log.date),
                      style: const TextStyle(
                        color:
                        Color(0xFF0F172A),
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      completed
                          ? 'Completed'
                          : 'Missed',
                      style: TextStyle(
                        color:
                        completed
                            ? const Color(
                          0xFF16A34A,
                        )
                            : const Color(
                          0xFF64748B,
                        ),
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
                  const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                    const Color(0xFFFFF7ED),
                    borderRadius:
                    BorderRadius.circular(
                      999,
                    ),
                  ),
                  child: Text(
                    '+${log.xpEarned} XP',
                    style: const TextStyle(
                      color:
                      Color(0xFFD97706),
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (showDivider)
          const Divider(
            height: 1,
            color: Color(0xFFE2E8F0),
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
              Icons.history_rounded,
              color: Color(0xFF2563EB),
              size: 24,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'No activity yet',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Complete a habit to see it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}