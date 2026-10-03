import '../../../../core/utils/date_utils.dart';

class WeekdayStatistics {
  const WeekdayStatistics({
    required this.date,
    required this.completedHabits,
    required this.targetHabits,
    required this.completionRate,
    required this.totalXP,
    required this.totalDurationMinutes,
    required this.isPerfectDay,
  });

  final DateTime date;

  final int completedHabits;

  final int targetHabits;

  final double completionRate;

  final int totalXP;

  final int totalDurationMinutes;

  final bool isPerfectDay;

  bool get isToday => AppDateUtils.isToday(date);

  bool get hasActivity => completedHabits > 0;

  WeekdayStatistics copyWith({
    DateTime? date,
    int? completedHabits,
    int? targetHabits,
    double? completionRate,
    int? totalXP,
    int? totalDurationMinutes,
    bool? isPerfectDay,
  }) {
    return WeekdayStatistics(
      date: date ?? this.date,
      completedHabits: completedHabits ?? this.completedHabits,
      targetHabits: targetHabits ?? this.targetHabits,
      completionRate: completionRate ?? this.completionRate,
      totalXP: totalXP ?? this.totalXP,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      isPerfectDay: isPerfectDay ?? this.isPerfectDay,
    );
  }
}
