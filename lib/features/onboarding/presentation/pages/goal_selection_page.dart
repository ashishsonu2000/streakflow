import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/onboarding_provider.dart';
import '../widgets/goal_chip.dart';
import '../widgets/onboarding_theme.dart';

class GoalSelectionPage extends ConsumerWidget {
  const GoalSelectionPage({super.key});

  static const goals = [
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Finance',
    'Mindfulness',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).goals;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: OnboardingCard(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OnboardingTitle(
                title: 'What would you like\nto improve?',
                subtitle: 'Pick one or more areas. You can change these later.',
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 9,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: goals.map((goal) {
                  return GoalChip(
                    label: goal,
                    selected: selected.contains(goal),
                    onTap: () => ref.read(onboardingProvider.notifier).toggleGoal(goal),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              Text(
                selected.isEmpty
                    ? 'Choose at least one area to get started'
                    : '${selected.length} ${selected.length == 1 ? 'area' : 'areas'} selected',
                style: const TextStyle(
                  color: OnboardingColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
