import '../models/habit.dart';
import '../models/habit_insight.dart';

class HabitInsightService {
  const HabitInsightService();

  List<HabitInsight> generate(
      Habit habit,
      ) {
    final insights = <HabitInsight>[];

    if (habit.currentStreak > 0) {
      insights.add(
        HabitInsight(
          icon: '🔥',
          message:
          'You are on a ${habit.currentStreak}-day streak.',
        ),
      );
    }

    if (habit.bestStreak > 0) {
      insights.add(
        HabitInsight(
          icon: '🏆',
          message:
          'Your best streak is ${habit.bestStreak} days.',
        ),
      );
    }

    if (habit.totalCompleted >= 10) {
      insights.add(
        HabitInsight(
          icon: '⭐',
          message:
          'You have completed this habit ${habit.totalCompleted} times.',
        ),
      );
    }

    final remaining =
        30 - habit.currentStreak;

    if (remaining > 0 &&
        remaining <= 7) {
      insights.add(
        HabitInsight(
          icon: '🎯',
          message:
          'Only $remaining days remain to reach a 30-day streak.',
        ),
      );
    }

    return insights;
  }
}