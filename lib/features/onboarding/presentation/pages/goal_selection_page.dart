import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/goal_chip.dart';

class GoalSelectionPage extends ConsumerWidget {
  const GoalSelectionPage({
    super.key,
  });

  static const goals = [
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Finance',
    'Mindfulness',
  ];

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final selected =
        ref.watch(
          onboardingProvider,
        ).goals;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'What would you like to improve?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
            goals
                .map(
                  (goal) => GoalChip(
                label: goal,
                selected: selected.contains(goal),
                onTap: () {
                  ref
                      .read(
                    onboardingProvider.notifier,
                  )
                      .toggleGoal(goal);
                },
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}