import 'package:flutter/material.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void success(
    BuildContext context,
    String message,
  ) {
    show(context, message);
  }

  static void error(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(message),
      ),
    );
  }

  static void info(BuildContext context, String message) {
    show(context, message);
  }
}
