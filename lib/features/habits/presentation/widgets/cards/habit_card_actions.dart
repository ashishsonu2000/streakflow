import 'package:flutter/material.dart';

import '../../../../../core/ui/actions/app_action_bar.dart';
import '../../../domain/models/habit.dart';

class HabitCardActions extends StatelessWidget {
  const HabitCardActions({
    super.key,
    required this.habit,
    required this.onComplete,
    required this.onDetails,
  });

  final Habit habit;
  final VoidCallback onComplete;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return AppActionBar(
      primary: FilledButton.icon(
        onPressed: onComplete,
        icon: const Icon(Icons.check),
        label: const Text('Complete'),
      ),
      secondary: OutlinedButton.icon(
        onPressed: onDetails,
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Details'),
      ),
    );
  }
}
