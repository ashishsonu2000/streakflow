import 'package:flutter/material.dart';

import '../../../domain/enums/habit_frequency.dart';
import '../../../domain/models/habit.dart';
import '../../../domain/models/habit_category.dart';

class HabitCardMetadata extends StatelessWidget {
  const HabitCardMetadata({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        _MetadataDot(
          label: _categoryLabel(
            habit.category,
          ),
          color: const Color(0xFF4ADE80),
        ),
        _MetadataDot(
          label: _frequencyLabel(
            habit.frequency,
          ),
          color: const Color(0xFF3B82F6),
        ),
        _MetadataDot(
          label: '${habit.targetPerDay}/day',
          color: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  String _categoryLabel(
      HabitCategory category,
      ) {
    switch (category) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.study:
        return 'Study';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.finance:
        return 'Finance';
      case HabitCategory.mindfulness:
        return 'Mindfulness';
      case HabitCategory.personal:
        return 'Personal';
      case HabitCategory.custom:
        return 'Custom';
      case HabitCategory.work:
        return 'Work';
      case HabitCategory.other:
        return 'Other';
      case HabitCategory.learning:
        return 'Learning';
    }
  }

  String _frequencyLabel(
      HabitFrequency frequency,
      ) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.custom:
        return 'Custom';
    }
  }
}

// =====================================================================
// METADATA DOT
// =====================================================================

class _MetadataDot extends StatelessWidget {
  const _MetadataDot({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}