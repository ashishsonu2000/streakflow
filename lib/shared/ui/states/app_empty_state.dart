import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;

  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 72,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

            if (buttonLabel != null &&
                onPressed != null) ...[
              const SizedBox(
                height: 24,
              ),
              FilledButton(
                onPressed: onPressed,
                child: Text(
                  buttonLabel!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}