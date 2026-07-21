import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/habit_menu_handler.dart';
import '../provider/filtered_habits_provider.dart';

import '../provider/habit_card_mapper_provider.dart';
import '../provider/habit_providers.dart';

import 'cards/habit_card.dart';
import 'habit_tile.dart';

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
          return const Center(
            child: Text(
              "No habits found",
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];

            final mapper = ref.read(habitCardViewModelMapperProvider);
            final card = mapper.map(habit);

            return HabitCard(
              habit: card,
              onTap: () {
                // Details page (later)
              },
              onMenuSelected: (action) async {
                await HabitMenuHandler.handle(
                  context,
                  ref,
                  habit,
                  action,
                );
              },
            );
          },
        );
      },
    );
  }
}
