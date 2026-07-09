import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../provider/habit_form_provider.dart';

class HabitPreviewCard extends ConsumerWidget {
  const HabitPreviewCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    final colorScheme = Theme.of(context).colorScheme;

    final icon = IconData(
      state.iconCodePoint,
      fontFamily: 'MaterialIcons',
    );

    final color = Color(state.colorValue);

    final title =
        state.title.trim().isEmpty ? 'Your Habit' : state.title.trim();

    final description = state.description.trim().isEmpty
        ? 'No description provided'
        : state.description.trim();

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: AppSpacing.lg),

            //----------------------------------------
            // Header
            //----------------------------------------

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
                const SizedBox(width: AppSpacing.md),
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

            const SizedBox(height: AppSpacing.lg),

            //----------------------------------------
            // Category & Frequency
            //----------------------------------------

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(
                    Icons.category,
                    size: 18,
                  ),
                  label: Text(state.category.name),
                ),
                Chip(
                  avatar: const Icon(
                    Icons.repeat,
                    size: 18,
                  ),
                  label: Text(state.frequency.name),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            const Divider(),

            const SizedBox(height: AppSpacing.md),

            //----------------------------------------
            // Statistics
            //----------------------------------------

            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.local_fire_department,
                    title: 'Streak',
                    value: '0',
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.flag,
                    title: 'Target',
                    value: '${state.targetPerDay}',
                    color: color,
                  ),
                ),
                const Expanded(
                  child: _InfoTile(
                    icon: Icons.star,
                    title: 'XP',
                    value: '0',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            //----------------------------------------
            // Reminder
            //----------------------------------------

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    state.reminderEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: state.reminderEnabled ? color : colorScheme.outline,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      state.hasReminder
                          ? 'Reminder • ${state.reminderHour!.toString().padLeft(2, '0')}:${state.reminderMinute!.toString().padLeft(2, '0')}'
                          : 'No reminder',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
