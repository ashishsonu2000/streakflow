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

    return Container(
      color: const Color(0xFFEAF0F6),
      child: habitsAsync.when(
        // =============================================================
        // LOADING
        // =============================================================

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2563EB),
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
              habitStatisticsProvider(habitId),
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
            physics:
            const ClampingScrollPhysics(),

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
                    motion:
                    const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed:
                            (_) async {
                          if (habit
                              .completedToday) {
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
                            ? const Color(
                          0xFFF97316,
                        )
                            : const Color(
                          0xFF16A34A,
                        ),

                        foregroundColor:
                        Colors.white,

                        icon:
                        habit.completedToday
                            ? Icons
                            .undo_rounded
                            : Icons
                            .check_circle_rounded,

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
                    motion:
                    const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed:
                            (_) async {
                          await HabitMenuHandler
                              .handle(
                            context: context,
                            ref: ref,
                            habit: habit,
                            action:
                            HabitMenuAction
                                .archive,
                          );
                        },

                        backgroundColor:
                        const Color(
                          0xFF64748B,
                        ),

                        foregroundColor:
                        Colors.white,

                        icon: Icons
                            .archive_outlined,

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
                    // DETAILS / STATISTICS
                    // -------------------------------------------------



                    // -------------------------------------------------
                    // POPUP MENU
                    // -------------------------------------------------

                    onMenuSelected:
                        (action) async {
                      await HabitMenuHandler
                          .handle(
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

class _HabitsEmptyState
    extends StatelessWidget {
  const _HabitsEmptyState();

  @override
  Widget build(
      BuildContext context,
      ) {
    return Center(
      child: SingleChildScrollView(
        padding:
        const EdgeInsets.fromLTRB(
          24,
          50,
          24,
          120,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            // =========================================================
            // ICON
            // =========================================================

            Container(
              width: 82,
              height: 82,
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFEFF6FF,
                ),
                borderRadius:
                BorderRadius.circular(
                  24,
                ),
                border: Border.all(
                  color: const Color(
                    0xFFBFDBFE,
                  ),
                ),
              ),
              child: const Icon(
                Icons
                    .check_circle_outline_rounded,
                size: 40,
                color: Color(
                  0xFF2563EB,
                ),
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            Text(
              'No habits yet',
              textAlign:
              TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
                color: const Color(
                  0xFF0F172A,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Create your first habit and start building your streak.',
              textAlign:
              TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: const Color(
                  0xFF64748B,
                ),
                height: 1.45,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFECFDF5,
                ),
                borderRadius:
                BorderRadius.circular(
                  999,
                ),
                border: Border.all(
                  color: const Color(
                    0xFFD1FAE5,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  const Icon(
                    Icons
                        .auto_awesome_rounded,
                    size: 16,
                    color: Color(
                      0xFF16A34A,
                    ),
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
                      const Color(
                        0xFF15803D,
                      ),
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

class _HabitsErrorState
    extends StatelessWidget {
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
        padding:
        const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFFFEF2F2,
                ),
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),
              child: const Icon(
                Icons
                    .error_outline_rounded,
                color: Color(
                  0xFFDC2626,
                ),
                size: 32,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              'Unable to load habits',
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
              '$error',
              textAlign:
              TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                const Color(
                  0xFF64748B,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}