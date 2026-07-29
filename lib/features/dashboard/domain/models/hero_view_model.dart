class HeroViewModel {
  const HeroViewModel(
      {required this.currentStreak,
      required this.bestStreak,
      required this.totalXP,
      required this.level,
      required this.completedToday,
      required this.totalToday,
      required this.nextLevelXP,
      required this.xpProgress,
      required this.target});

  final int currentStreak;

  final int target;

  final int bestStreak;

  final int totalXP;

  final int level;

  final int completedToday;

  final int totalToday;

  final int nextLevelXP;

  final double xpProgress;

  double get progress {
    if (totalToday == 0) {
      return 0;
    }

    return completedToday / totalToday;
  }

  int get progressPercentage => (progress * 100).round();
}
