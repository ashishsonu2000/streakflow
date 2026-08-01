import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/calendar_provider.dart';

class SelectedDayCard extends ConsumerWidget {
  const SelectedDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendar = ref.watch(calendarProvider);

    return calendar.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (calendar) {
        final day = calendar.selectedDay;

        if (day == null) {
          return const SizedBox.shrink();
        }

        final progress =
            day.totalHabits == 0 ? 0.0 : day.completedHabits / day.totalHabits;

        final theme = Theme.of(context);

        return Card(
          margin: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16,
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //--------------------------------------------------
                // Header
                //--------------------------------------------------

                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat.yMMMMEEEEd().format(day.date),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                //--------------------------------------------------
                // Progress
                //--------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${(progress * 100).round()}%",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "${day.completedHabits} of ${day.totalHabits} habits completed",
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                //--------------------------------------------------
                // Statistics
                //--------------------------------------------------

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatChip(
                      icon: Icons.check_circle,
                      label: "${day.completedHabits} Completed",
                    ),
                    _StatChip(
                      icon: Icons.star,
                      label: "${day.totalXP} XP",
                    ),
                    _StatChip(
                      icon: Icons.timer,
                      label: "${day.totalDuration} min",
                    ),
                    if (day.dominantMood != null)
                      _StatChip(
                        icon: Icons.sentiment_satisfied_alt,
                        label: day.dominantMood!.name,
                      ),
                  ],
                ),

                const SizedBox(height: 28),

                //--------------------------------------------------
                // Habits
                //--------------------------------------------------

                Text(
                  "Habits",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (day.habits.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No activity on this day",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...day.habits.map(
                    (habit) => Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerHighest,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: habit.completed
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                          child: Icon(
                            habit.completed ? Icons.check : Icons.close,
                            color: habit.completed ? Colors.green : Colors.grey,
                          ),
                        ),
                        title: Text(habit.title),
                        subtitle:
                            habit.notes.isEmpty ? null : Text(habit.notes),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+${habit.xpEarned}",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("XP"),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
      ),
      label: Text(label),
    );
  }
}
