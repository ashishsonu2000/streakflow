import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';

class HabitPreviewCard extends ConsumerWidget {
  const HabitPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    final color = Color(state.colorValue);

    final icon = IconData(
      state.iconCodePoint,
      fontFamily: 'MaterialIcons',
    );

    final title =
        state.title.trim().isEmpty ? "Your Habit" : state.title.trim();

    final description = state.description.trim().isEmpty
        ? "No description"
        : state.description.trim();

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Preview",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: color,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.category, size: 18),
                  label: Text(state.category.name),
                ),
                Chip(
                  avatar: const Icon(Icons.repeat, size: 18),
                  label: Text(state.frequency.name),
                ),
                Chip(
                  avatar: const Icon(Icons.flag, size: 18),
                  label: Text(
                    "${state.targetPerDay} / day",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                state.reminderEnabled
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: state.reminderEnabled ? color : Colors.grey,
              ),
              title: Text(
                state.reminderEnabled
                    ? "Reminder Enabled"
                    : "Reminder Disabled",
              ),
              subtitle: state.hasReminder
                  ? Text(
                      "${state.reminderHour!.toString().padLeft(2, '0')}:${state.reminderMinute!.toString().padLeft(2, '0')}",
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
