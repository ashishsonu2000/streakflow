class YearlyStatistics {
  const YearlyStatistics({
    required this.year,
    required this.completionRate,
    required this.totalScheduled,
    required this.totalCompleted,
    required this.totalMissed,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.perfectDays,
    required this.months,
  });

  final int year;

  /// Overall completion rate for the year.
  ///
  /// 0.0 - 1.0
  final double completionRate;

  /// Total scheduled habit occurrences.
  final int totalScheduled;

  /// Total completed habit occurrences.
  final int totalCompleted;

  /// Total missed scheduled occurrences.
  final int totalMissed;

  /// Total XP earned during the year.
  final int totalXP;

  /// Total duration in minutes.
  final int totalDurationMinutes;

  /// Number of perfect days.
  final int perfectDays;

  /// Statistics for each month.
  final List<YearlyMonthStatistics> months;

  double get completionPercentage =>
      completionRate * 100;

  double get missedPercentage {
    if (totalScheduled == 0) {
      return 0;
    }

    return totalMissed / totalScheduled * 100;
  }

  YearlyMonthStatistics? get bestMonth {
    if (months.isEmpty) {
      return null;
    }

    return months.reduce(
          (a, b) {
        if (b.completionRate > a.completionRate) {
          return b;
        }

        return a;
      },
    );
  }

  YearlyMonthStatistics? get worstMonth {
    if (months.isEmpty) {
      return null;
    }

    return months.reduce(
          (a, b) {
        if (b.completionRate < a.completionRate) {
          return b;
        }

        return a;
      },
    );
  }
}

class YearlyMonthStatistics {
  const YearlyMonthStatistics({
    required this.month,
    required this.completionRate,
    required this.totalScheduled,
    required this.totalCompleted,
    required this.totalMissed,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.perfectDays,
  });

  /// 1 = January ... 12 = December.
  final int month;

  final double completionRate;

  final int totalScheduled;

  final int totalCompleted;

  final int totalMissed;

  final int totalXP;

  final int totalDurationMinutes;

  final int perfectDays;

  double get completionPercentage =>
      completionRate * 100;
}