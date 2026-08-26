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
        // =========================================================
        // CATEGORY
        // =========================================================

        _MetadataDot(
          label: _categoryLabel(habit.category),
          color: const Color(0xFF4ADE80),
        ),

        // =========================================================
        // FREQUENCY
        // =========================================================

        _MetadataDot(
          label: _frequencyLabel(habit.frequency),
          color: const Color(0xFF3B82F6),
        ),

        // =========================================================
        // TARGET
        // =========================================================

        _MetadataDot(
          label: '${habit.targetPerDay}/day',
          color: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  // =================================================================
  // CATEGORY
  // =================================================================

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

  // =================================================================
  // FREQUENCY
  // =================================================================

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF334155),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}