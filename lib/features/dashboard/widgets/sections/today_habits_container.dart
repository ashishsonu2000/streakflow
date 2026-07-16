import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/models/today_habit_view_model.dart';
import '../../presentation/providers/dashboard_provider.dart';
import '../../presentation/widgets/today/today_habits_section.dart';

class TodayHabitsContainer extends ConsumerWidget {
  const TodayHabitsContainer({
    super.key,
    required this.habits,
  });

  final List<TodayHabitViewModel> habits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TodayHabitsSection(
      habits: habits,
      onHabitComplete: (habit) async {
        await ref.read(habitNotifierProvider.notifier).completeHabit(habit.id);

        ref.invalidate(dashboardProvider);
      },
      onHabitTap: (habit) {
        // TODO: Navigate to Habit Details
      },
    );
  }
}
