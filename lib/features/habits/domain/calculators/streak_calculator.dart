import '../../../../core/utils/date_utils.dart';
import '../../data/entities/habit_log_entity.dart';
import '../models/completion_status.dart';

class StreakResult {
  final int currentStreak;
  final int longestStreak;
  final int completedDays;
  final int perfectDays;

  const StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.completedDays,
    required this.perfectDays,
  });
}

class StreakCalculator {
  const StreakCalculator();

  static StreakResult calculate(List<HabitLogEntity> logs) {
    if (logs.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        completedDays: 0,
        perfectDays: 0,
      );
    }

    final dates = logs
        .where((e) => e.status == CompletionStatus.completed)
        .map(
          (e) => DateTime(
            e.date.year,
            e.date.month,
            e.date.day,
          ),
        )
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        completedDays: 0,
        perfectDays: 0,
      );
    }

    final completedDays = dates.length;

    final perfectDays = completedDays;

    int longest = 1;
    int current = 1;

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;

      if (diff == 1) {
        current++;
      } else {
        if (current > longest) {
          longest = current;
        }
        current = 1;
      }
    }

    if (current > longest) {
      longest = current;
    }

    int currentStreak = 0;

    final todayOnly = AppDateUtils.today;
    final yesterday = todayOnly.subtract(const Duration(days: 1));

    if (dates.last == todayOnly || dates.last == yesterday) {
      currentStreak = 1;

      for (int i = dates.length - 1; i > 0; i--) {
        final diff = dates[i].difference(dates[i - 1]).inDays;

        if (diff == 1) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longest,
      completedDays: completedDays,
      perfectDays: perfectDays,
    );
  }
}
