import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/ui/charts/monthly_completion_chart.dart';
import '../../../../core/ui/charts/weekly_completion_chart.dart';
import '../../../../shared/ui/layouts/responsive_layout.dart';

import '../../domain/models/habit.dart';

import '../analytics/cards/completion_rate_card.dart';

import '../provider/habit_logs_provider.dart';
import '../provider/habit_providers.dart';

import '../providers/habit_detail_analytics_provider.dart';

import '../widgets/analytics/activity_heatmap.dart';
import '../widgets/details/activity/activity_section.dart';
import '../widgets/details/habit_header.dart';
import '../widgets/details/habit_information_card.dart';
import '../widgets/details/habit_statistics.dart';

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
      habitProvider(
        habitId,
      ),
    );

    return habitAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
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
          habitLogsProvider(
            habit.id,
          ),
        );

        final analyticsAsync = ref.watch(
          habitDetailAnalyticsProvider(
            habit,
          ),
        );

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Habit Details',
            ),
          ),
          body: SafeArea(
            child: ResponsiveLayout(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    HabitHeader(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    _TodayStatusCard(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    HabitStatistics(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    analyticsAsync.when(
                      loading: () => const Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                      error: (
                          error,
                          stack,
                          ) =>
                          Text(
                            error.toString(),
                          ),
                      data: (analytics) {
                        return Column(
                          children: [
                            CompletionRateCard(
                              completionRate:
                              analytics
                                  .completionRate,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            WeeklyCompletionChart(
                              analytics:
                              analytics,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            MonthlyCompletionChart(
                              analytics:
                              analytics,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            ActivityHeatmap(
                              days: analytics.heatmap,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    HabitInformation(
                      habit: habit,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    logsAsync.when(
                      loading: () => const Center(
                        child:
                        CircularProgressIndicator(),
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
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(
          20,
        ),
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
              color:
              statusColor.withValues(
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
                      .textTheme.titleSmall
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
                      .textTheme.bodySmall
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