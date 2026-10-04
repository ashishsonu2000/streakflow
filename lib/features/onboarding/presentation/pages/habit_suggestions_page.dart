import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/suggested_habit.dart';
import '../../domain/services/habit_suggestion_service.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_theme.dart';

/// "Start with a few habits": ready-made habits for the goals picked on
/// the previous step. The first one of each goal is pre-selected; the
/// selected ones are created when onboarding finishes.
class HabitSuggestionsPage extends ConsumerWidget {
  const HabitSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final selected = onboarding.selectedSuggestionIds;
    final service = const HabitSuggestionService();

    final groups = [
      for (final goal in onboarding.goals)
        (goal: goal, habits: service.getSuggestions([goal])),
    ].where((group) => group.habits.isNotEmpty).toList();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: OnboardingCard(
          padding: const EdgeInsets.fromLTRB(18, 26, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OnboardingTitle(
                title: 'Start with a few habits',
                subtitle: 'Picked for your goals. Tap to choose; '
                    'you can edit or add more anytime.',
              ),
              const SizedBox(height: 20),
              if (groups.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Go back and pick an area to see suggestions, '
                    'or continue and create your own habits.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: OnboardingColors.muted),
                  ),
                )
              else
                for (final group in groups) ...[
                  _GoalHeader(goal: group.goal),
                  for (final habit in group.habits)
                    _SuggestionTile(
                      habit: habit,
                      selected: selected.contains(habit.id),
                      onTap: () => ref
                          .read(onboardingProvider.notifier)
                          .toggleSuggestion(habit.id),
                    ),
                  const SizedBox(height: 8),
                ],
              const SizedBox(height: 6),
              Text(
                selected.isEmpty
                    ? 'No habits selected. You can add them later.'
                    : '${selected.length} '
                        '${selected.length == 1 ? 'habit' : 'habits'} selected',
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

class _GoalHeader extends StatelessWidget {
  const _GoalHeader({required this.goal});

  final String goal;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
        child: Text(
          goal.toUpperCase(),
          style: const TextStyle(
            color: OnboardingColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.habit,
    required this.selected,
    required this.onTap,
  });

  final SuggestedHabit habit;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.colorValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        selected: selected,
        label: habit.title,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: selected ? OnboardingColors.selected : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? OnboardingColors.indigo
                      : OnboardingColors.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(habit.icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(
                            color: OnboardingColors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${habit.description} · ${habit.scheduleLabel}',
                          style: const TextStyle(
                            color: OnboardingColors.muted,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.add_circle_outline_rounded,
                    color: selected
                        ? OnboardingColors.indigo
                        : OnboardingColors.muted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
