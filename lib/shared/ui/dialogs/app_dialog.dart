import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../buttons/buttons.dart';
import 'dialog_action.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
    this.icon,
  });

  final String title;
  final String message;
  final IconData? icon;
  final List<DialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon == null ? null : Icon(icon),
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.large,
      ),
      actions: actions.map((action) {
        if (action.isPrimary) {
          return PrimaryButton(
            label: action.label,
            icon: action.icon,
            onPressed: action.onPressed,
          );
        }

        if (action.isDestructive) {
          return DangerButton(
            label: action.label,
            icon: action.icon ?? Icons.delete_outline,
            onPressed: action.onPressed,
          );
        }

        return SecondaryButton(
          label: action.label,
          icon: action.icon,
          onPressed: action.onPressed,
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Factory dialogs
  // ---------------------------------------------------------------------------

  factory AppDialog.confirm({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return AppDialog(
      title: title,
      message: message,
      icon: Icons.help_outline,
      actions: [
        DialogAction(
          label: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        DialogAction(
          label: 'Confirm',
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ],
    );
  }

  factory AppDialog.delete({
    required BuildContext context,
    required VoidCallback onDelete,
  }) {
    return AppDialog(
      title: 'Delete Habit',
      message:
          'This action cannot be undone. Are you sure you want to continue?',
      icon: Icons.delete_outline,
      actions: [
        DialogAction(
          label: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        DialogAction(
          label: 'Delete',
          isDestructive: true,
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
        ),
      ],
    );
  }

  factory AppDialog.discard({
    required BuildContext context,
    required VoidCallback onDiscard,
  }) {
    return AppDialog(
      title: 'Discard Changes',
      message: 'You have unsaved changes. Do you want to discard them?',
      icon: Icons.warning_amber_outlined,
      actions: [
        DialogAction(
          label: 'Keep Editing',
          onPressed: () => Navigator.pop(context),
        ),
        DialogAction(
          label: 'Discard',
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            onDiscard();
          },
        ),
      ],
    );
  }
}
