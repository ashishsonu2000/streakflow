import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/ui/layouts/layouts.dart';
import '../../../onboarding/domain/models/suggested_habit.dart';
import '../../../onboarding/domain/services/habit_suggestion_service.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/models/habit.dart';
import '../provider/habit_form_provider.dart';
import '../provider/habit_providers.dart';

/// "Ideas for you" on the Create Habit form: suggested habits for the
/// goals chosen in onboarding. Tapping one fills the form; nothing is
/// created until the user saves. Habits the user already has are hidden.
class HabitIdeasSection extends ConsumerWidget {
  const HabitIdeasSection({super.key});

  static const _service = HabitSuggestionService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).valueOrNull;
    if (state == null) {
      return const SizedBox.shrink();
    }

    final goals = ref.watch(profileProvider).valueOrNull?.goals ?? const [];
    final existingTitles = <String>[
      for (final habit
          in ref.watch(allActiveHabitsProvider).valueOrNull ?? const <Habit>[])
        habit.title,
    ];

    final ideas = _service.ideasFor(
      goals: goals,
      existingTitles: existingTitles,
    );
    final everything = _service.withoutExisting(
      _service.getSuggestions(_service.allGoals),
      existingTitles,
    );

    if (everything.isEmpty) {
      return const SizedBox.shrink();
    }

    void apply(SuggestedHabit idea) =>
        ref.read(habitFormProvider.notifier).applySuggestion(idea);

    return AppSection(
      title: 'Ideas for you',
      subtitle: goals.isEmpty
          ? 'Tap one to fill in the form, then adjust it.'
          : 'Based on your goals. Tap one to fill in the form.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final idea in ideas)
                _IdeaChip(
                  idea: idea,
                  selected: state.title == idea.title,
                  onTap: () => apply(idea),
                ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () async {
                final picked = await showModalBottomSheet<SuggestedHabit>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => _AllIdeasSheet(
                    goals: _service.allGoals,
                    ideas: everything,
                  ),
                );
                if (picked != null) {
                  apply(picked);
                }
              },
              icon: const Icon(Icons.lightbulb_outline_rounded),
              label: const Text('More ideas'),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdeaChip extends StatelessWidget {
  const _IdeaChip({
    required this.idea,
    required this.selected,
    required this.onTap,
  });

  final SuggestedHabit idea;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(idea.colorValue);

    return FilterChip(
      selected: selected,
      showCheckmark: false,
      avatar: Icon(idea.icon, size: 18, color: color),
      label: Text(idea.title),
      onSelected: (_) => onTap(),
    );
  }
}

/// Every suggestion the user doesn't have yet, grouped by goal.
class _AllIdeasSheet extends StatelessWidget {
  const _AllIdeasSheet({required this.goals, required this.ideas});

  final List<String> goals;
  final List<SuggestedHabit> ideas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = const HabitSuggestionService();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Text('Habit ideas', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Pick one to fill in the form.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            for (final goal in goals) ...[
              if (service
                  .getSuggestions([goal])
                  .any((idea) => ideas.contains(idea))) ...[
                const SizedBox(height: 16),
                Text(
                  goal.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                for (final idea in service.getSuggestions([goal]))
                  if (ideas.contains(idea))
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor:
                            Color(idea.colorValue).withValues(alpha: 0.14),
                        child: Icon(idea.icon, color: Color(idea.colorValue)),
                      ),
                      title: Text(idea.title),
                      subtitle: Text(
                        '${idea.description} · ${idea.scheduleLabel}',
                      ),
                      onTap: () => Navigator.of(context).pop(idea),
                    ),
              ],
            ],
          ],
        );
      },
    );
  }
}
