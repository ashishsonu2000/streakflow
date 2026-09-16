import 'package:flutter/material.dart';

import '../../domain/models/quick_action_model.dart';
import '../sections/section_title.dart';
import 'quick_action_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.actions,
    this.onActionTap,
  });

  final List<QuickActionModel> actions;
  final ValueChanged<QuickActionModel>? onActionTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width >= 900
        ? 4
        : width >= 600
            ? 3
            : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Quick Actions",
        ),
        const SizedBox(height: 16),
        GridView.builder(
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 95,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];

            return QuickActionCard(
              title: action.title,
              icon: action.icon,
              onTap: () => onActionTap?.call(action),
            );
          },
        ),
      ],
    );
  }
}
