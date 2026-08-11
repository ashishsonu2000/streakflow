import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/habits_summary_provider.dart';

import '../widgets/habit_filter_bar.dart';
import '../widgets/habit_sort_button.dart';
import '../widgets/habits_list.dart';
import '../widgets/search/habit_search_bar.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final theme = Theme.of(context);

    final summaryAsync = ref.watch(
      habitsSummaryProvider,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // ===============================================================
      // APP BAR
      // ===============================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Habits',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Build consistency, one day at a time',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.09,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Add Habit',
                onPressed: () {
                  context.pushNamed(
                    'habit-form',
                  );
                },
                icon: Icon(
                  Icons.add_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),

      // ===============================================================
      // BODY
      // ===============================================================

      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // =========================================================
            // SUMMARY
            // =========================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                0,
              ),
              child: summaryAsync.when(
                loading: () {
                  return const _SummaryLoading();
                },
                error: (_, __) {
                  return const SizedBox.shrink();
                },
                data: (summary) {
                  return _HabitsSummarySection(
                    summary: summary,
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // =========================================================
            // SEARCH
            // =========================================================

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: HabitSearchBar(),
            ),

            const SizedBox(height: 10),

            // =========================================================
            // FILTER + SORT
            // =========================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: HabitFilterBar(),
                  ),
                  const SizedBox(width: 8),
                  const HabitSortButton(),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // =========================================================
            // HABIT LIST
            // =========================================================

            const Expanded(
              child: HabitsList(),
            ),
          ],
        ),
      ),

      // ===============================================================
      // FAB
      // ===============================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(
            'habit-form',
          );
        },
        elevation: 3,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Habit',
        ),
      ),
    );
  }
}

// =====================================================================
// SUMMARY SECTION
// =====================================================================

class _HabitsSummarySection extends StatelessWidget {
  const _HabitsSummarySection({
    required this.summary,
  });

  final HabitsSummary summary;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: Colors.green,
            value: '${summary.completedToday}',
            label: 'Completed',
            subtitle:
            '${summary.completionPercentage}% today',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.orange,
            value: '${summary.bestStreak}',
            label: 'Best Streak',
            subtitle: summary.bestStreak == 1
                ? 'day'
                : 'days',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            icon: Icons.stars_rounded,
            iconColor: Colors.amber.shade700,
            value: '${summary.totalXP}',
            label: 'XP',
            subtitle: 'total',
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// SUMMARY CARD
// =====================================================================

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 124,
      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        10,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: 0.65,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===========================================================
          // ICON
          // ===========================================================

          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 17,
            ),
          ),

          const SizedBox(height: 8),

          // ===========================================================
          // VALUE
          // ===========================================================

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          ),

          const SizedBox(height: 3),

          // ===========================================================
          // LABEL
          // ===========================================================

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 2),

          // ===========================================================
          // SUBTITLE
          // ===========================================================

          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontSize: 10,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SUMMARY LOADING
// =====================================================================

class _SummaryLoading extends StatelessWidget {
  const _SummaryLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: List.generate(
        3,
            (index) {
          return Expanded(
            child: Container(
              height: 124,
              margin: EdgeInsets.only(
                right: index == 2 ? 0 : 10,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          );
        },
      ),
    );
  }
}