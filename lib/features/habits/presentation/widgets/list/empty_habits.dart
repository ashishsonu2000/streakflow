import 'package:flutter/material.dart';

class EmptyHabits extends StatelessWidget {
  const EmptyHabits({
    super.key,
    this.onCreate,
  });

  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.spa_rounded,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              "Start Your First Habit",
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              "Consistency begins with one small step.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text("Create Habit"),
            ),
          ],
        ),
      ),
    );
  }
}
