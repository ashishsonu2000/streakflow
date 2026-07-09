import 'package:flutter/material.dart';

import 'app_confirmation_dialog.dart';

class DeleteHabitDialog {
  const DeleteHabitDialog._();

  static Future<bool> show(
    BuildContext context,
    String habitTitle,
  ) {
    return AppConfirmationDialog.show(
      context,
      title: "Delete Habit",
      message:
          'Are you sure you want to delete "$habitTitle"?\n\nThis action cannot be undone.',
      confirmText: "Delete",
      confirmColor: Colors.red,
      icon: Icons.delete_outline,
    );
  }
}
