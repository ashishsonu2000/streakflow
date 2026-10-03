import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';



import '../../../domain/models/habit.dart';
import '../../provider/habit_logs_provider.dart';
import 'recent_activity_empty.dart';
import 'recent_activity_list.dart';

class HabitRecentActivity extends ConsumerWidget {
  const HabitRecentActivity({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync =
    ref.watch(habitLogsProvider(habit.id));

    return AppSectionCard(
      title: 'Recent Activity',
      child: logsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
            ),
          );
        },
        data: (logs) {
          if (logs.isEmpty) {
            return const RecentActivityEmpty();
          }

          return RecentActivityList(
            logs: logs.reversed.take(5).toList(),
          );
        },
      ),
    );
  }
}