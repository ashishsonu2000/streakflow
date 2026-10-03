import 'package:flutter/material.dart';

import '../models/habit_category.dart';

extension HabitCategoryExtension on HabitCategory {
  /// Display Name
  String get label {
    switch (this) {
      case HabitCategory.health:
        return "Health";

      case HabitCategory.fitness:
        return "Fitness";

      case HabitCategory.study:
        return "Study";

      case HabitCategory.productivity:
        return "Productivity";

      case HabitCategory.finance:
        return "Finance";

      case HabitCategory.mindfulness:
        return "Mindfulness";

      case HabitCategory.personal:
        return "Personal";

      case HabitCategory.custom:
        return "Custom";

      case HabitCategory.work:
        return "Work";

      case HabitCategory.other:
        return "Other";

      case HabitCategory.learning:
        return "Learning";
    }
  }

  /// Material Icon
  IconData get icon {
    switch (this) {
      case HabitCategory.health:
        return Icons.favorite_rounded;

      case HabitCategory.fitness:
        return Icons.fitness_center_rounded;

      case HabitCategory.study:
        return Icons.school_rounded;

      case HabitCategory.productivity:
        return Icons.bolt_rounded;

      case HabitCategory.finance:
        return Icons.account_balance_wallet_rounded;

      case HabitCategory.mindfulness:
        return Icons.self_improvement_rounded;

      case HabitCategory.personal:
        return Icons.person_rounded;

      case HabitCategory.custom:
        return Icons.auto_awesome_rounded;

      case HabitCategory.work:
        return Icons.work_rounded;

      case HabitCategory.other:
        return Icons.category_rounded;

      case HabitCategory.learning:
        return Icons.menu_book_rounded;
    }
  }

  /// Primary Color
  Color get color {
    switch (this) {
      case HabitCategory.health:
        return Colors.red;

      case HabitCategory.fitness:
        return Colors.deepOrange;

      case HabitCategory.study:
        return Colors.indigo;

      case HabitCategory.productivity:
        return Colors.teal;

      case HabitCategory.finance:
        return Colors.green;

      case HabitCategory.mindfulness:
        return Colors.purple;

      case HabitCategory.personal:
        return Colors.blue;

      case HabitCategory.custom:
        return Colors.deepPurple;

      case HabitCategory.work:
        return Colors.brown;

      case HabitCategory.other:
        return Colors.grey;

      case HabitCategory.learning:
        return Colors.cyan;
    }
  }

  /// Light Background Color
  Color get backgroundColor => color.withValues(alpha: .12);

  /// Emoji (for achievements, notifications, etc.)
  String get emoji {
    switch (this) {
      case HabitCategory.health:
        return "❤️";

      case HabitCategory.fitness:
        return "💪";

      case HabitCategory.study:
        return "🎓";

      case HabitCategory.productivity:
        return "⚡";

      case HabitCategory.finance:
        return "💰";

      case HabitCategory.mindfulness:
        return "🧘";

      case HabitCategory.personal:
        return "👤";

      case HabitCategory.custom:
        return "✨";

      case HabitCategory.work:
        return "💼";

      case HabitCategory.other:
        return "📌";

      case HabitCategory.learning:
        return "📚";
    }
  }
}
