import 'package:flutter/material.dart';

import 'app_confirmation_dialog.dart';

class ArchiveHabitDialog {
  const ArchiveHabitDialog._();

  static Future<bool> show(
    BuildContext context,
    String habitTitle,
  ) {
    return AppConfirmationDialog.show(
      context,
      title: "Archive Habit",
      message: 'Archive "$habitTitle"?\n\nYou can restore it later.',
      confirmText: "Archive",
      confirmColor: Colors.orange,
      icon: Icons.archive_outlined,
    );
  }
}
