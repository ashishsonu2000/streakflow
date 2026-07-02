import 'package:flutter/material.dart';

import '../../../habits/presentation/pages/add_habit_sheet.dart';
import '../../domain/models/quick_action.dart';
import '../../domain/models/quick_action_type.dart';
import '../sections/section_title.dart';
import 'quick_action_card.dart';

class QuickActions extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActions({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Quick Actions",
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (_, index) {
            final action = actions[index];

            return QuickActionCard(
              action: action,
              onTap: () => _handleAction(context, action),
            );
          },
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, QuickAction action) {
    debugPrint('Tapped: ${action.type}');

    switch (action.type) {
      case QuickActionType.addHabit:
        debugPrint('Opening Add Habit Sheet');
        AddHabitSheet.show(context);
        break;

      case QuickActionType.calendar:
        debugPrint('Calendar');
        break;

      case QuickActionType.statistics:
        debugPrint('Statistics');
        break;

      case QuickActionType.settings:
        debugPrint('Settings');
        break;
    }
  }
}
