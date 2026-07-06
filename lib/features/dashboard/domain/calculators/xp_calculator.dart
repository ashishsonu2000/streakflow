import '../../../habits/domain/models/habit.dart';

class XPCalculator {
  const XPCalculator._();

  /// Total XP earned across all habits.
  static int calculateTotalXP(List<Habit> habits) {
    return habits.fold(
      0,
      (sum, habit) => sum + habit.xp,
    );
  }

  /// User level.
  ///
  /// Every 250 XP = 1 Level
  static int calculateLevel(int totalXP) {
    return (totalXP ~/ 250) + 1;
  }

  /// XP required for next level.
  static int calculateXPForNextLevel(int level) {
    return level * 250;
  }

  /// Achievement badge.
  static String calculateAchievement(int currentStreak) {
    if (currentStreak >= 365) {
      return "Legend";
    }

    if (currentStreak >= 180) {
      return "Master";
    }

    if (currentStreak >= 90) {
      return "Elite";
    }

    if (currentStreak >= 30) {
      return "Consistency Champion";
    }

    if (currentStreak >= 14) {
      return "On Fire";
    }

    if (currentStreak >= 7) {
      return "Rising Star";
    }

    if (currentStreak >= 3) {
      return "Getting Started";
    }

    return "Beginner";
  }
}
