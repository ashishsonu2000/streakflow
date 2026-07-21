import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/ui/ui.dart';
import '../provider/habit_card_list_provider.dart';
import '../provider/habits_view_provider.dart';

import '../widgets/filters/habit_search_bar.dart';
import '../widgets/habit_filter_bar.dart';
import '../widgets/list/habit_list.dart';

class HabitsPage extends ConsumerStatefulWidget {
  const HabitsPage({super.key});

  @override
  ConsumerState<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends ConsumerState<HabitsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(habitCardListProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AppFab(
        icon: Icons.add,
        label: 'Add Habit',
        tooltip: 'Create Habit',
        onPressed: () {
          context.push(AppRoutes.habitForm);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: HabitSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(habitsViewProvider.notifier).setSearch(value);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HabitFilterBar(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cardsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(
                  child: Text(error.toString()),
                ),
                data: (cards) => HabitList(
                  habits: cards,
                  onHabitTap: (habit) {
                    context.pushNamed(
                      'habit-detail',
                      pathParameters: {
                        'id': habit.id,
                      },
                      extra: habit.habit,
                    );
                  },
                  onMenuSelected: (habit, action) {
                    // TODO:
                    // Next step is to refactor HabitCardViewModel
                    // to wrap the domain Habit. Then simply call:
                    //
                    // HabitMenuHandler.handle(
                    //   context,
                    //   ref,
                    //   habit.habit,
                    //   action,
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
