import 'package:flutter/material.dart';

import '../../../../../core/ui/actions/app_action_bar.dart';
import '../../../../../core/ui/feedback/feedback_service.dart';
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
    final completed = habit.completedToday;

    return AppActionBar(
      primary: FilledButton.icon(
        onPressed: completed
            ? null
            : () {
          FeedbackService.playXpSound();
          FeedbackService.lightImpact();
          onComplete();
        },
        icon: Icon(
          completed
              ? Icons.check_circle_rounded
              : Icons.check_rounded,
        ),
        label: Text(
          completed ? 'Completed' : 'Complete',
        ),
      ),

      secondary: OutlinedButton.icon(
        onPressed: () {
          FeedbackService.selection();
          onDetails();
        },
        icon: const Icon(
          Icons.visibility_outlined,
        ),
        label: const Text(
          'Details',
        ),
      ),
    );
  }
}