import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/animations/fade_slide.dart';
import '../../../../shared/widgets/states/app_empty_state.dart';

import '../helpers/habit_menu_handler.dart';
import '../provider/filtered_habits_provider.dart';

import 'actions/habit_popup_menu.dart';
import 'cards/habit_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitsList extends ConsumerWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(filteredHabitsProvider);

    return habitsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (habits) {
        if (habits.isEmpty) {
          return const AppEmptyState(
            icon: Icons.check_circle_outline,
            title: 'No habits yet',
            message: 'Create your first habit to start building your streak.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 100,
          ),
          itemCount: habits.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final habit = habits[index];

            return FadeSlide(
              delay: Duration(milliseconds: index * 40),
              child: Slidable(
                key: ValueKey(habit.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
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
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      icon: Icons.archive_outlined,
                      label: 'Archive',
                    ),
                  ],
                ),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        // TODO: CompleteHabitUseCase
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.check_circle,
                      label: 'Complete',
                    ),
                  ],
                ),
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
                  onComplete: () {
                    // TODO: Wire CompleteHabitUseCase
                  },
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
    );
  }
}
