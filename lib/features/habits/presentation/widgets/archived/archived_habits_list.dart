import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/ui/empty/app_empty_state.dart';
import '../../provider/archived_habits_provider.dart';
import 'archived_habit_card.dart';

class ArchivedHabitsList extends ConsumerWidget {
  const ArchivedHabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(archivedHabitsProvider);

    return habits.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text(e.toString()),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const AppEmptyState(
            subtitle: "Archived habits",
            icon: Icons.archive_outlined,
            title: 'No archived habits',
            message: 'Archived habits will appear here.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return ArchivedHabitCard(
              habit: items[index],
            );
          },
        );
      },
    );
  }
}
