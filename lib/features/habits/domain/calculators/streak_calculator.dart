import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../data/entities/habit_log_entity.dart';
import '../enums/completion_status.dart';

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
  //const StreakCalculator();

  static StreakResult calculate(List<HabitLogEntity> logs) {
    debugPrint('========================================');
    debugPrint('===== STREAK CALCULATOR =====');
    debugPrint('Logs: ${logs.length}');

    if (logs.isEmpty) {
      debugPrint('RETURN -> logs.isEmpty');

      return const StreakResult(
        currentStreak: 0,
        longestStreak: 0,
        completedDays: 0,
        perfectDays: 0,
      );
    }

    for (final log in logs) {
      debugPrint(
        'Log -> status=${log.status}, date=${log.date}',
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

    debugPrint('Dates count: ${dates.length}');

    for (final date in dates) {
      debugPrint('Date -> $date');
    }

    if (dates.isEmpty) {
      debugPrint('RETURN -> dates.isEmpty');

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

    debugPrint('----------------------------------------');
    debugPrint('Calculating longest streak');

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;

      debugPrint(
        '${dates[i - 1]} -> ${dates[i]} = $diff day(s)',
      );

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

    debugPrint('Longest streak = $longest');

    int currentStreak = 0;

    final today = AppDateUtils.today;
    final yesterday = today.subtract(const Duration(days: 1));

    final lastDate = dates.last;

    final isToday = lastDate.year == today.year &&
        lastDate.month == today.month &&
        lastDate.day == today.day;

    final isYesterday = lastDate.year == yesterday.year &&
        lastDate.month == yesterday.month &&
        lastDate.day == yesterday.day;

    debugPrint('----------------------------------------');
    debugPrint('Today      : $today');
    debugPrint('Yesterday  : $yesterday');
    debugPrint('Last Date  : $lastDate');
    debugPrint('isToday    : $isToday');
    debugPrint('isYesterday: $isYesterday');

    if (isToday || isYesterday) {
      currentStreak = 1;

      for (int i = dates.length - 1; i > 0; i--) {
        final diff = dates[i].difference(dates[i - 1]).inDays;

        debugPrint(
          'Reverse: ${dates[i]} -> ${dates[i - 1]} = $diff',
        );

        if (diff == 1) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    debugPrint('Current streak = $currentStreak');
    debugPrint('========================================');

    return StreakResult(
      currentStreak: currentStreak,
      longestStreak: longest,
      completedDays: completedDays,
      perfectDays: perfectDays,
    );
  }
}
