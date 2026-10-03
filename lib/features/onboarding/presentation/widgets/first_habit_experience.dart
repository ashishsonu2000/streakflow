import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/presentation/providers/suggested_habits_provider.dart';
import '../providers/create_suggested_habit_provider.dart';

class FirstHabitExperience extends ConsumerWidget {
  const FirstHabitExperience({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final suggestions = ref.watch(
      suggestedHabitsProvider,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 40,
            ),

            const Icon(
              Icons.local_fire_department,
              size: 72,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              "Let's build your first habit.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 32,
            ),

            Column(
              children: suggestions.map(
                    (habit) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          habit.title,
                        ),
                        subtitle: Text(
                          habit.description,
                        ),
                        trailing: FilledButton(
                          onPressed: () async {
                            await ref
                                .read(
                              createSuggestedHabitProvider,
                            )
                                .execute(
                              habit,
                            );
                          },
                          child: const Text(
                            'Create',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),

            SizedBox(
              height: 24,
            ),

            OutlinedButton(
              onPressed: () {
                // Open habit form.
              },
              child: const Text(
                'Create Custom Habit',
              ),
            ),

            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}