import 'package:flutter/material.dart';

import 'app_confirmation_dialog.dart';

class DuplicateHabitDialog {
  const DuplicateHabitDialog._();

  static Future<bool> show(
    BuildContext context,
    String habitTitle,
  ) {
    return AppConfirmationDialog.show(
      context,
      title: "Duplicate Habit",
      message: 'Create a copy of "$habitTitle"?',
      confirmText: "Duplicate",
      confirmColor: Colors.blue,
      icon: Icons.copy_outlined,
    );
  }
}
