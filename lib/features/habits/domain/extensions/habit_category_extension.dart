import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/habit_category.dart';

extension HabitCategoryExtension on HabitCategory {
  String get displayName {
    switch (this) {
      case HabitCategory.health:
        return 'Health';

      case HabitCategory.fitness:
        return 'Fitness';

      case HabitCategory.study:
        return 'Study';

      case HabitCategory.work:
        return 'Work';

      case HabitCategory.personal:
        return 'Personal';

      case HabitCategory.finance:
        return 'Finance';

      case HabitCategory.productivity:
        return 'Productivity';

      case HabitCategory.mindfulness:
        return 'Mindfulness';

      case HabitCategory.custom:
        return 'Custom';

      case HabitCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case HabitCategory.health:
        return '❤️';

      case HabitCategory.fitness:
        return '💪';

      case HabitCategory.study:
        return '📚';

      case HabitCategory.work:
        return '💼';

      case HabitCategory.personal:
        return '🌱';

      case HabitCategory.finance:
        return '💰';

      case HabitCategory.productivity:
        return '🚀';

      case HabitCategory.mindfulness:
        return '🧘';

      case HabitCategory.custom:
        return '🎯';

      case HabitCategory.other:
        return '✨';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitCategory.health:
        return Icons.favorite;

      case HabitCategory.fitness:
        return Icons.fitness_center;

      case HabitCategory.study:
        return Icons.menu_book;

      case HabitCategory.work:
        return Icons.work_outline;

      case HabitCategory.personal:
        return Icons.person_outline;

      case HabitCategory.finance:
        return Icons.account_balance_wallet_outlined;

      case HabitCategory.productivity:
        return Icons.rocket_launch_outlined;

      case HabitCategory.mindfulness:
        return Icons.self_improvement;

      case HabitCategory.custom:
        return Icons.category_outlined;

      case HabitCategory.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case HabitCategory.health:
        return Colors.red;

      case HabitCategory.fitness:
        return Colors.orange;

      case HabitCategory.study:
        return Colors.indigo;

      case HabitCategory.work:
        return Colors.blue;

      case HabitCategory.personal:
        return Colors.green;

      case HabitCategory.finance:
        return Colors.teal;

      case HabitCategory.productivity:
        return Colors.deepPurple;

      case HabitCategory.mindfulness:
        return Colors.purple;

      case HabitCategory.custom:
        return Colors.brown;

      case HabitCategory.other:
        return Colors.grey;
    }
  }
}
