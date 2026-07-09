import 'package:flutter/material.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    this.confirmColor,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmText;
  final Color? confirmColor;
  final IconData? icon;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    Color? confirmColor,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final color = confirmColor ?? Theme.of(context).colorScheme.primary;

    return AlertDialog(
      icon: icon != null
          ? Icon(
              icon,
              color: color,
              size: 32,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: color,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
