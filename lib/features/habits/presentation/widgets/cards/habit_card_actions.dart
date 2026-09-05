import 'package:flutter/material.dart';

import '../../../../../core/ui/actions/app_action_bar.dart';
import '../../../../../core/ui/buttons/gradient_button.dart';
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
    final colors = Theme.of(context).colorScheme;

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
      primary: _PrimaryAction(
        label: label,
        completed: completed,
        status: status,
        enabled: canAct,
        onPressed: () {
          if (completed) {
            _confirmUndo(context);
          } else {
            _confirmCompletion(context);
          }
        },
      ),

      secondary: OutlinedButton.icon(
        onPressed: () {
          FeedbackService.selection();
          onDetails();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(
            color: colors.primary.withValues(
              alpha: 0.45,
            ),
            width: 1.2,
          ),
          backgroundColor: colors.primary.withValues(
            alpha: Theme.of(context).brightness ==
                Brightness.dark
                ? 0.08
                : 0.04,
          ),
          minimumSize: const Size(
            0,
            46,
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(13),
          ),
        ),
        icon: const Icon(
          Icons.visibility_outlined,
          size: 18,
        ),
        label: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ===================================================================
  // COMPLETE CONFIRMATION
  // ===================================================================

  Future<void> _confirmCompletion(
      BuildContext context,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Complete habit?',
          ),
          content: Text(
            'Mark "${habit.title}" as completed for today?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            _DialogGradientButton(
              label: 'Complete',
              icon: Icons.check_rounded,
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
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

  // ===================================================================
  // UNDO CONFIRMATION
  // ===================================================================

  Future<void> _confirmUndo(
      BuildContext context,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Undo completion?',
          ),
          content: Text(
            'Remove "${habit.title}" from today\'s completed habits?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            _DialogGradientButton(
              label: 'Undo',
              icon: Icons.undo_rounded,
              isUndo: true,
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
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

// =====================================================================
// PRIMARY ACTION
// =====================================================================

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.completed,
    required this.status,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool completed;
  final HabitScheduleStatus status;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final IconData icon;

    if (completed) {
      icon = Icons.undo_rounded;
    } else if (status ==
        HabitScheduleStatus.upcoming) {
      icon = Icons.schedule_outlined;
    } else if (status ==
        HabitScheduleStatus.expired) {
      icon = Icons.event_busy_outlined;
    } else {
      icon = Icons.check_rounded;
    }

    if (!enabled) {
      return OutlinedButton.icon(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          minimumSize:
          const Size(0, 46),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(13),
          ),
        ),
        icon: Icon(
          icon,
          size: 18,
        ),
        label: Text(label),
      );
    }

    if (completed) {
      return _GradientAction(
        label: label,
        icon: icon,
        colors: const [
          Color(0xFF9A3412),
          Color(0xFFF97316),
        ],
        onPressed: onPressed,
      );
    }

    return GradientButton(
      label: label,
      icon: icon,
      height: 46,
      borderRadius: 13,
      onPressed: onPressed,
    );
  }
}

// =====================================================================
// GRADIENT ACTION
// =====================================================================

class _GradientAction extends StatelessWidget {
  const _GradientAction({
    required this.label,
    required this.icon,
    required this.colors,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(13),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(
              alpha: 0.18,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius:
          BorderRadius.circular(13),
          child: SizedBox(
            height: 46,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// DIALOG BUTTON
// =====================================================================

class _DialogGradientButton
    extends StatelessWidget {
  const _DialogGradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isUndo = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isUndo;

  @override
  Widget build(BuildContext context) {
    final colors = isUndo
        ? const [
      Color(0xFF9A3412),
      Color(0xFFF97316),
    ]
        : const [
      Color(0xFF172554),
      Color(0xFF2563EB),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
        icon: Icon(
          icon,
          size: 17,
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}