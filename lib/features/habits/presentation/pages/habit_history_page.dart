import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/completion_status.dart';
import '../../domain/models/habit_log.dart';
import '../provider/habit_logs_provider.dart';

class HabitHistoryPage extends ConsumerWidget {
  const HabitHistoryPage({
    super.key,
    required this.habitId,
    required this.habitTitle,
  });

  final String habitId;
  final String habitTitle;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final logsAsync = ref.watch(
      habitLogsProvider(habitId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$habitTitle History',
        ),
      ),
      body: logsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _ErrorState(
          error: error,
          onRetry: () {
            ref.invalidate(
              habitLogsProvider(habitId),
            );
          },
        ),
        data: (logs) {
          if (logs.isEmpty) {
            return const _EmptyHistory();
          }

          final groupedLogs =
          _groupByMonth(logs);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                habitLogsProvider(habitId),
              );

              await ref.read(
                habitLogsProvider(habitId).future,
              );
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                32,
              ),
              children: [
                for (final entry
                in groupedLogs.entries) ...[
                  _MonthHeader(
                    title: entry.key,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ...entry.value.map(
                        (log) => Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: _HistoryTile(
                        log: log,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, List<HabitLog>> _groupByMonth(
      List<HabitLog> logs,
      ) {
    final sorted = [...logs]
      ..sort(
            (a, b) => b.date.compareTo(a.date),
      );

    final result =
    <String, List<HabitLog>>{};

    for (final log in sorted) {
      final key = _monthName(
        log.date,
      );

      result.putIfAbsent(
        key,
            () => [],
      );

      result[key]!.add(log);
    }

    return result;
  }

  String _monthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}

// ===================================================================
// MONTH HEADER
// ===================================================================

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 2,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ===================================================================
// HISTORY TILE
// ===================================================================

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.log,
  });

  final HabitLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completed =
        log.status ==
            CompletionStatus.completed;

    final statusColor = completed
        ? Colors.green
        : theme.colorScheme.outline;

    final statusIcon = completed
        ? Icons.check_circle_rounded
        : Icons.event_note_outlined;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =======================================================
            // STATUS
            // =======================================================

            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            // =======================================================
            // MAIN INFORMATION
            // =======================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(log.date),
                    style: theme
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    completed
                        ? 'Completed'
                        : 'Recorded activity',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: statusColor,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  // =================================================
                  // COMPLETION TIME
                  // =================================================

                  if (log.completedAt != null) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    _InfoLine(
                      icon:
                      Icons.access_time_rounded,
                      text: _formatTime(
                        log.completedAt!,
                      ),
                    ),
                  ],

                  // =================================================
                  // DURATION
                  // =================================================

                  if (log.durationMinutes > 0) ...[
                    const SizedBox(
                      height: 6,
                    ),
                    _InfoLine(
                      icon:
                      Icons.timer_outlined,
                      text:
                      '${log.durationMinutes} min',
                    ),
                  ],

                  // =================================================
                  // NOTES
                  // =================================================

                  if (log.notes.isNotEmpty) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      log.notes,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .outline,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            // =======================================================
            // XP
            // =======================================================

            if (completed && log.xpEarned > 0)
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 17,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '+${log.xpEarned}',
                        style: theme
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'XP',
                    style: theme
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      color: theme
                          .colorScheme
                          .outline,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute =
    date.minute.toString().padLeft(2, '0');

    final period = hour >= 12
        ? 'PM'
        : 'AM';

    final displayHour =
    hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }
}

// ===================================================================
// INFO LINE
// ===================================================================

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// EMPTY STATE
// ===================================================================

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 52,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'No history yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Complete this habit to start building your history.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// ERROR STATE
// ===================================================================

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Unable to load history',
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}