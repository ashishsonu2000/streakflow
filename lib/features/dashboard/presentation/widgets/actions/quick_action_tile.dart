import 'package:flutter/material.dart';

import '../../../domain/models/quick_action_model.dart';
import 'quick_action_icon.dart';
import 'quick_action_label.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.action,
    this.onTap,
  });

  final QuickActionModel action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Spacer(),
              QuickActionIcon(
                icon: action.icon,
              ),
              const SizedBox(height: 10),
              QuickActionLabel(
                title: action.title,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
