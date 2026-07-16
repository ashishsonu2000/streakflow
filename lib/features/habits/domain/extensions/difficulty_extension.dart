import 'package:flutter/material.dart';

import '../models/difficulty.dart';

extension DifficultyExtension on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return "Easy";

      case Difficulty.medium:
        return "Medium";

      case Difficulty.hard:
        return "Hard";
    }
  }

  IconData get icon {
    switch (this) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied_alt_rounded;

      case Difficulty.medium:
        return Icons.trending_up_rounded;

      case Difficulty.hard:
        return Icons.local_fire_department_rounded;
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.easy:
        return Colors.green;

      case Difficulty.medium:
        return Colors.orange;

      case Difficulty.hard:
        return Colors.red;
    }
  }

  Color get backgroundColor => color.withOpacity(.12);
}
