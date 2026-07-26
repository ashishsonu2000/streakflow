import 'package:flutter/material.dart';

import 'app_swipe_action.dart';

class AppSwipeActions extends StatelessWidget {
  const AppSwipeActions({
    super.key,
    required this.child,
    required this.startAction,
    required this.endAction,
  });

  final Widget child;

  final AppSwipeAction? startAction;

  final AppSwipeAction? endAction;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: _buildBackground(
        context,
        startAction,
        Alignment.centerLeft,
      ),
      secondaryBackground: _buildBackground(
        context,
        endAction,
        Alignment.centerRight,
      ),
      confirmDismiss: (_) async => false,
      child: child,
    );
  }

  Widget _buildBackground(
    BuildContext context,
    AppSwipeAction? action,
    Alignment alignment,
  ) {
    if (action == null) {
      return const SizedBox();
    }

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: action.color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            action.icon,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            action.label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
