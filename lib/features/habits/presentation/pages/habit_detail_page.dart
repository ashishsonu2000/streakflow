import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/ui/cards/app_section_card.dart';
import '../../../../shared/ui/layouts/responsive_layout.dart';

import '../../domain/models/habit.dart';
import '../widgets/details/habit_header.dart';
import '../widgets/details/habit_information_card.dart';
import '../widgets/details/habit_statistics.dart';

class HabitDetailPage extends ConsumerWidget {
  const HabitDetailPage({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                HabitHeader(
                  habit: habit,
                ),
                const SizedBox(height: 24),
                HabitStatistics(
                  habit: habit,
                ),
                const SizedBox(height: 24),
                HabitInformation(
                  habit: habit,
                ),
                const SizedBox(height: 24),
                AppSectionCard(
                  title: 'Recent Activity',
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Activity history coming soon.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
