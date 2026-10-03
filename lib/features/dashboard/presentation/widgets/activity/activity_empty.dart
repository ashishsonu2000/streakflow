import 'package:flutter/material.dart';

class ActivityEmpty extends StatelessWidget {
  const ActivityEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 54,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              "No activity yet",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Complete your first habit\nand your timeline will appear here.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
