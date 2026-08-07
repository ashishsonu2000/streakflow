import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/providers/provider_exports.dart';

import '../../../../../core/ui/actions/app_action_bar.dart';
import '../../../../../core/ui/chips/app_status_chip.dart';
import '../../../../../core/ui/headers/app_card_header.dart';
import '../../../../../core/ui/icons/habit_icon.dart';
import '../../../../../core/ui/metadata/app_metadata_row.dart';
import '../../../../../core/ui/spacing/app_spacing.dart';

import '../../../../../shared/ui/cards/app_card.dart';
import '../../../domain/models/habit.dart';
import '../../provider/habit_providers.dart';

class ArchivedHabitCard extends ConsumerWidget {
  const ArchivedHabitCard({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardHeader(
            leading: HabitIcon(
              iconCodePoint: habit.iconCodePoint,
              color: Color(habit.colorValue),
            ),
            title: habit.title,
            subtitle: habit.description,
            trailing: const StatusChip(
              status: AppStatus.archived,
            ),
          ),
          const Gap.vertical(AppSpacing.lg),
          AppMetadataRow(
            items: [
              MetadataItem(
                icon: Icons.category_outlined,
                label: habit.category.name,
              ),
              MetadataItem(
                icon: Icons.repeat,
                label: habit.frequency.name,
              ),
            ],
          ),
          const Gap.vertical(AppSpacing.xl),
          AppActionBar(
            primary: FilledButton.tonalIcon(
              onPressed: () async {
                await ref
                    .read(habitCommandNotifierProvider.notifier)
                    .restoreHabit(habit.id);
              },
              icon: const Icon(Icons.restore),
              label: const Text('Restore'),
            ),
            secondary: FilledButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete habit'),
                        content: const Text(
                          'This will permanently delete this habit and its history. This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ) ??
                    false;

                if (!confirmed) return;

                await ref
                    .read(habitCommandNotifierProvider.notifier)
                    .deleteHabit(habit.id);
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete'),
            ),
          )
        ],
      ),
    );
  }
}
