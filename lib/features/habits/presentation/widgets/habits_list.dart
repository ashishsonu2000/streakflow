import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/animations/fade_slide.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';

import '../helpers/habit_menu_handler.dart';
import '../provider/filtered_habits_provider.dart';
import '../provider/habit_statistics_provider.dart';
import '../providers/provider_exports.dart';

import 'actions/habit_popup_menu.dart';
import 'cards/habit_card.dart';

class HabitsList extends ConsumerWidget {
  const HabitsList({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final habitsAsync = ref.watch(
      filteredHabitsProvider,
    );

    final commandNotifier = ref.read(
      habitCommandNotifierProvider.notifier,
    );

    return Container(
      color: colors.surface,
      child: habitsAsync.when(
        // =============================================================
        // LOADING
        // =============================================================

        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: colors.primary,
            ),
          );
        },

        // =============================================================
        // ERROR
        // =============================================================

        error: (error, stack) {
          return _HabitsErrorState(
            error: error,
          );
        },

        // =============================================================
        // DATA
        // =============================================================

        data: (habits) {
          if (habits.isEmpty) {
            return const _HabitsEmptyState();
          }

          // ===========================================================
          // REFRESH HABIT-DEPENDENT DATA
          // ===========================================================

          Future<void> refreshHabitData(
              String habitId,
              ) async {
            ref.invalidate(
              filteredHabitsProvider,
            );

            ref.invalidate(
              dashboardProvider,
            );

            ref.invalidate(
              calendarProvider,
            );

            ref.invalidate(
              habitStatisticsProvider(
                HabitStatisticsQuery(
                  habitId: habitId,
                ),
              ),
            );
          }

          // ===========================================================
          // COMPLETE
          // ===========================================================

          Future<void> completeHabit(
              String habitId,
              ) async {
            await commandNotifier.completeHabit(
              habitId,
            );

            await refreshHabitData(
              habitId,
            );
          }

          // ===========================================================
          // UNDO
          // ===========================================================

          Future<void> uncompleteHabit(
              String habitId,
              ) async {
            await commandNotifier.uncompleteHabit(
              habitId,
            );

            await refreshHabitData(
              habitId,
            );
          }

          // ===========================================================
          // HABIT LIST
          // ===========================================================

          return ListView.separated(
            physics: const ClampingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              110,
            ),

            itemCount: habits.length,

            separatorBuilder: (_, __) {
              return const SizedBox(
                height: 14,
              );
            },

            itemBuilder: (
                context,
                index,
                ) {
              final habit = habits[index];

              return FadeSlide(
                delay: Duration(
                  milliseconds: index * 35,
                ),
                child: Slidable(
                  key: ValueKey(
                    habit.id,
                  ),

                  closeOnScroll: true,

                  // =================================================
                  // LEFT → COMPLETE / UNDO
                  // =================================================

                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          if (habit.completedToday) {
                            await uncompleteHabit(
                              habit.id,
                            );
                          } else {
                            await completeHabit(
                              habit.id,
                            );
                          }
                        },

                        backgroundColor:
                        habit.completedToday
                            ? const Color(0xFFF97316)
                            : const Color(0xFF16A34A),

                        foregroundColor: Colors.white,

                        icon:
                        habit.completedToday
                            ? Icons.undo_rounded
                            : Icons.check_circle_rounded,

                        label:
                        habit.completedToday
                            ? 'Undo'
                            : 'Complete',
                      ),
                    ],
                  ),

                  // =================================================
                  // RIGHT → ARCHIVE
                  // =================================================

                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          await HabitMenuHandler.handle(
                            context: context,
                            ref: ref,
                            habit: habit,
                            action: HabitMenuAction.archive,
                          );
                        },

                        backgroundColor:
                        colors.outline,

                        foregroundColor: Colors.white,

                        icon: Icons.archive_outlined,

                        label: 'Archive',
                      ),
                    ],
                  ),

                  // =================================================
                  // HABIT CARD
                  // =================================================

                  child: HabitCard(
                    habit: habit,

                    // -------------------------------------------------
                    // OPEN DETAILS / EDIT
                    // -------------------------------------------------

                    onTap: () {
                      context.pushNamed(
                        'habit-detail',
                        pathParameters: {
                          'id': habit.id,
                        },
                        extra: habit,
                      );
                    },

                    // -------------------------------------------------
                    // COMPLETE
                    // -------------------------------------------------

                    onComplete: () async {
                      await completeHabit(
                        habit.id,
                      );
                    },

                    // -------------------------------------------------
                    // UNDO
                    // -------------------------------------------------

                    onUndo: () async {
                      await uncompleteHabit(
                        habit.id,
                      );
                    },

                    // -------------------------------------------------
                    // POPUP MENU
                    // -------------------------------------------------

                    onMenuSelected: (action) async {
                      await HabitMenuHandler.handle(
                        context: context,
                        ref: ref,
                        habit: habit,
                        action: action,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _HabitsEmptyState extends StatelessWidget {
  const _HabitsEmptyState();

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          50,
          24,
          120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =========================================================
            // ICON
            // =========================================================

            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: colors.primary.withValues(
                  alpha: isDark ? 0.14 : 0.08,
                ),
                borderRadius: BorderRadius.circular(
                  24,
                ),
                border: Border.all(
                  color: colors.primary.withValues(
                    alpha: isDark ? 0.35 : 0.22,
                  ),
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 40,
                color: colors.primary,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // =========================================================
            // TITLE
            // =========================================================

            Text(
              'No habits yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =========================================================
            // DESCRIPTION
            // =========================================================

            Text(
              'Create your first habit and start building your streak.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // =========================================================
            // POSITIVE MESSAGE
            // =========================================================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(
                  alpha: isDark ? 0.12 : 0.08,
                ),
                borderRadius: BorderRadius.circular(
                  999,
                ),
                border: Border.all(
                  color: colors.secondary.withValues(
                    alpha: isDark ? 0.28 : 0.18,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: colors.secondary,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Small steps. Big consistency.',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// ERROR STATE
// =====================================================================

class _HabitsErrorState extends StatelessWidget {
  const _HabitsErrorState({
    required this.error,
  });

  final Object error;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.error.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: colors.error.withValues(
                    alpha: 0.25,
                  ),
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colors.error,
                size: 32,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              'Unable to load habits',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              '$error',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}