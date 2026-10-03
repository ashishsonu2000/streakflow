import 'package:flutter/material.dart';

import '../../../../../core/ui/design/app_breakpoints.dart';
import '../../../domain/models/quick_action_model.dart';
import 'quick_action_tile.dart';

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
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount = width >= AppBreakpoints.desktop
            ? 4
            : width >= AppBreakpoints.tablet
                ? 3
                : 2;

        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: actions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 140,
                  ),
                  itemBuilder: (_, index) {
                    final action = actions[index];

                    return QuickActionTile(
                      action: action,
                      onTap: () => onActionTap?.call(action),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
