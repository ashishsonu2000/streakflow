import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/ui/layouts/responsive_layout.dart';

import '../../domain/models/habit.dart';

import '../provider/habit_logs_provider.dart';
import '../provider/habit_providers.dart';

import '../widgets/cards/habit_card_progress.dart';
import '../widgets/details/activity/activity_section.dart';
import '../widgets/details/habit_header.dart';
import '../widgets/details/habit_information_card.dart';


class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({
    super.key,
    required this.habitId,
  });

  final String habitId;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final theme = Theme.of(context);

    final habitAsync = ref.watch(
      habitProvider(habitId),
    );

    return habitAsync.when(
      // =========================================================
      // LOADING
      // =========================================================

      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      // =========================================================
      // ERROR
      // =========================================================

      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Habit Details',
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),

      // =========================================================
      // DATA
      // =========================================================

      data: (habit) {
        if (habit == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Habit not found',
              ),
            ),
          );
        }

        final logsAsync = ref.watch(
          habitLogsProvider(habit.id),
        );

        return Scaffold(
          backgroundColor:
          theme.scaffoldBackgroundColor,

          // =======================================================
          // APP BAR
          // =======================================================

          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Habit Details',
            ),
          ),

          // =======================================================
          // BODY
          // =======================================================

          body: SafeArea(
            child: ResponsiveLayout(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    // =================================================
                    // HABIT NAME + DESCRIPTION
                    // =================================================

                    HabitHeader(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    // =================================================
                    // TODAY'S STATUS
                    // =================================================

                    _TodayStatusCard(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =================================================
                    // TODAY'S PROGRESS
                    // =================================================

                    HabitCardProgress(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =================================================
                    // BASIC INFORMATION
                    //
                    // Schedule
                    // Reminder
                    // Start / End date
                    // =================================================

                    HabitInformation(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =================================================
                    // STATISTICS
                    // =================================================

                    _StatisticsCard(
                      habit: habit,
                      onPressed: () {
                        context.pushNamed(
                          'habit-statistics',
                          pathParameters: {
                            'id': habit.id,
                          },
                          extra: habit,
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =================================================
                    // RECENT ACTIVITY
                    // =================================================

                    _SectionTitle(
                      title: 'Recent Activity',
                      icon: Icons.history_rounded,
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    logsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 24,
                        ),
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      ),
                      error: (
                          error,
                          stack,
                          ) =>
                          Text(
                            error.toString(),
                          ),
                      data: (logs) =>
                          ActivitySection(
                            logs: logs,
                          ),
                    ),

                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===================================================================
// TODAY STATUS
// ===================================================================

class _TodayStatusCard extends StatelessWidget {
  const _TodayStatusCard({
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    final completed =
        habit.completedToday;

    final statusColor = completed
        ? Colors.green
        : theme.colorScheme.primary;

    final statusIcon = completed
        ? Icons.check_circle_rounded
        : Icons.radio_button_unchecked_rounded;

    final statusTitle = completed
        ? 'Completed today'
        : 'Not completed yet';

    final statusSubtitle = completed
        ? 'Great job! Keep your streak going.'
        : 'Complete this habit today to keep your streak.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: statusColor.withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(
            alpha: 0.16,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: statusColor.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
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
                  statusSubtitle,
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
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// STATISTICS ENTRY
// ===================================================================

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({
    required this.habit,
    required this.onPressed,
  });

  final Habit habit;
  final VoidCallback onPressed;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    return Material(
      color: theme
          .colorScheme
          .surfaceContainerHighest
          .withValues(
        alpha: 0.45,
      ),
      borderRadius:
      BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius:
        BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .primary
                      .withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: theme
                      .colorScheme
                      .primary,
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habit Statistics',
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
                      'View completion trends, streaks, progress and insights.',
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
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme
                    .colorScheme
                    .outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// SECTION TITLE
// ===================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: theme
              .textTheme
              .titleMedium
              ?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}