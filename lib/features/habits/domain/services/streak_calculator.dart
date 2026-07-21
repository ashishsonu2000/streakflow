import '../../data/entities/habit_log_entity.dart';
import '../enums/completion_status.dart';

class StreakResult {
  const StreakResult({
    required this.currentStreak,
    required this.bestStreak,
  });

  final int currentStreak;
  final int bestStreak;
}

class StreakCalculator {
  const StreakCalculator();

  StreakResult calculate(
    List<HabitLogEntity> logs,
  ) {
    if (logs.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        bestStreak: 0,
      );
    }

    final completedDates = logs
        .where((e) => e.status == CompletionStatus.completed)
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .toList()
      ..sort();

    if (completedDates.isEmpty) {
      return const StreakResult(
        currentStreak: 0,
        bestStreak: 0,
      );
    }

    final best = _calculateBest(completedDates);
    final current = _calculateCurrent(completedDates);

    return StreakResult(
      currentStreak: current,
      bestStreak: best,
    );
  }

  int _calculateBest(List<DateTime> dates) {
    var best = 1;
    var streak = 1;

    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;

      if (diff == 1) {
        streak++;
      } else {
        streak = 1;
      }

      if (streak > best) {
        best = streak;
      }
    }

    return best;
  }

  int _calculateCurrent(List<DateTime> dates) {
    final today = _dateOnly(DateTime.now());

    if (dates.last != today) {
      return 0;
    }

    var streak = 1;

    for (var i = dates.length - 1; i > 0; i--) {
      final diff = dates[i].difference(dates[i - 1]).inDays;

      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
    );
  }
}
