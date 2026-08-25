import 'package:flutter/material.dart';

import '../../../../../core/ui/actions/app_action_bar.dart';
import '../../../../../core/ui/feedback/feedback_service.dart';
import '../../../domain/models/habit.dart';
import '../../../domain/models/habit_schedule_status.dart';

class HabitCardActions extends StatelessWidget {
  const HabitCardActions({
    super.key,
    required this.habit,
    required this.onComplete,
    required this.onUndo,
    required this.onDetails,
  });

  final Habit habit;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final completed = habit.completedToday;
    final status = habit.scheduleStatus;

    final canAct =
        status == HabitScheduleStatus.active;

    final String label;

    if (completed) {
      label = 'Undo';
    } else if (status ==
        HabitScheduleStatus.upcoming) {
      label = 'Not Started';
    } else if (status ==
        HabitScheduleStatus.expired) {
      label = 'Expired';
    } else {
      label = 'Complete';
    }

    return AppActionBar(
      primary: FilledButton.icon(
        onPressed: canAct
            ? () {
          if (completed) {
            _confirmUndo(context);
          } else {
            _confirmCompletion(context);
          }
        }
            : null,
        icon: Icon(
          completed
              ? Icons.undo_rounded
              : status ==
              HabitScheduleStatus.upcoming
              ? Icons.schedule_outlined
              : status ==
              HabitScheduleStatus.expired
              ? Icons.event_busy_outlined
              : Icons.check_rounded,
        ),
        label: Text(label),
      ),
      secondary: OutlinedButton.icon(
        onPressed: () {
          FeedbackService.selection();
          onDetails();
        },
        icon: const Icon(
          Icons.visibility_outlined,
        ),
        label: const Text('Details'),
      ),
    );
  }

  Future<void> _confirmCompletion(
      BuildContext context,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Complete habit?',
          ),
          content: Text(
            'Mark "${habit.title}" as completed for today?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(true);
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    FeedbackService.playXpSound();
    FeedbackService.lightImpact();

    onComplete();
  }

  Future<void> _confirmUndo(
      BuildContext context,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Undo completion?',
          ),
          content: Text(
            'Remove "${habit.title}" from today\'s completed habits?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(true);
              },
              child: const Text('Undo'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    FeedbackService.selection();
    FeedbackService.lightImpact();

    onUndo();
  }
}