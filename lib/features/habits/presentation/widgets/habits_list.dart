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
    final habitsAsync = ref.watch(
      filteredHabitsProvider,
    );

    final commandNotifier = ref.read(
      habitCommandNotifierProvider.notifier,
    );

    return habitsAsync.when(
      // ===============================================================
      // LOADING
      // ===============================================================

      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      // ===============================================================
      // ERROR
      // ===============================================================

      error: (error, stack) {
        return _HabitsErrorState(
          error: error,
        );
      },

      // ===============================================================
      // DATA
      // ===============================================================

      data: (habits) {
        if (habits.isEmpty) {
          return const _HabitsEmptyState();
        }

        // =============================================================
        // REFRESH HABIT-DEPENDENT DATA
        // =============================================================

        Future<void> refreshHabitData(
            String habitId,
            ) async {
          // Refresh habit list
          ref.invalidate(
            filteredHabitsProvider,
          );

          // Refresh dashboard
          ref.invalidate(
            dashboardProvider,
          );

          // Refresh calendar
          ref.invalidate(
            calendarProvider,
          );

          // Refresh this habit's statistics
          ref.invalidate(
            habitStatisticsProvider(habitId),
          );
        }

        // =============================================================
        // COMPLETE HABIT
        // =============================================================

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

        // =============================================================
        // UNDO HABIT
        // =============================================================

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

        // =============================================================
        // HABIT LIST
        // =============================================================

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            110,
          ),
          itemCount: habits.length,
          separatorBuilder: (_, __) {
            return const SizedBox(
              height: 12,
            );
          },
          itemBuilder: (
              context,
              index,
              ) {
            final habit = habits[index];

            return FadeSlide(
              delay: Duration(
                milliseconds: index * 40,
              ),
              child: Slidable(
                key: ValueKey(
                  habit.id,
                ),

                // =====================================================
                // SLIDE CONFIGURATION
                // =====================================================

                closeOnScroll: true,

                // =====================================================
                // LEFT → COMPLETE / UNDO
                // =====================================================

                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: habit.completedToday
                          ? (_) async {
                        await uncompleteHabit(
                          habit.id,
                        );
                      }
                          : (_) async {
                        await completeHabit(
                          habit.id,
                        );
                      },
                      backgroundColor:
                      habit.completedToday
                          ? Colors.orange
                          : Colors.green,
                      foregroundColor:
                      Colors.white,
                      icon: habit.completedToday
                          ? Icons.undo_rounded
                          : Icons.check_circle_rounded,
                      label: habit.completedToday
                          ? 'Undo'
                          : 'Complete',
                    ),
                  ],
                ),

                // =====================================================
                // RIGHT → ARCHIVE
                // =====================================================

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
                          action:
                          HabitMenuAction.archive,
                        );
                      },
                      backgroundColor:
                      Colors.orange,
                      foregroundColor:
                      Colors.white,
                      icon:
                      Icons.archive_outlined,
                      label: 'Archive',
                    ),
                  ],
                ),

                // =====================================================
                // HABIT CARD
                // =====================================================

                child: HabitCard(
                  habit: habit,

                  onTap: () {
                    context.pushNamed(
                      'habit-detail',
                      pathParameters: {
                        'id': habit.id,
                      },
                      extra: habit,
                    );
                  },

                  onComplete: () async {
                    await completeHabit(habit.id);
                  },

                  onUndo: () async {
                    await uncompleteHabit(habit.id);
                  },

                  onStatistics: () {
                    context.pushNamed(
                      'habit-statistics',
                      pathParameters: {
                        'id': habit.id,
                      },
                      extra: habit,
                    );
                  },

                  onMenuSelected: (action) async {
                    await HabitMenuHandler.handle(
                      context: context,
                      ref: ref,
                      habit: habit,
                      action: action,
                    );
                  },
                )
              ),
            );
          },
        );
      },
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
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          40,
          24,
          120,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(
                  alpha: 0.09,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 38,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'No habits yet',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Create your first habit and start building your streak.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .outline,
                height: 1.4,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Small steps. Big consistency.',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                      color:
                      Colors.green.shade700,
                      fontWeight:
                      FontWeight.w600,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .error
                    .withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .error,
                size: 32,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Unable to load habits',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow:
              TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}