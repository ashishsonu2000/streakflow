import 'package:equatable/equatable.dart';

class StreakSummary extends Equatable {
  final int currentStreak;
  final int longestStreak;

  final int completedDays;
  final int targetDays;

  /// 0.0 - 1.0
  final double completion;

  // -------- Gamification --------

  final int level;

  final int xp;

  final int xpTarget;

  final String achievement;

  const StreakSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.completedDays,
    required this.targetDays,
    required this.completion,
    required this.level,
    required this.xp,
    required this.xpTarget,
    required this.achievement,
  });

  double get xpProgress => xp / xpTarget;

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        completedDays,
        targetDays,
        completion,
        level,
        xp,
        xpTarget,
        achievement,
      ];
}
