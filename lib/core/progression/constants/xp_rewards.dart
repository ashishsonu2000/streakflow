abstract final class XpRewards {
  const XpRewards._();

  /// Base reward for completing a habit once.
  static const int habitCompletion = 10;

  /// Bonus when every scheduled habit is completed.
  static const int perfectDay = 25;

  /// Weekly completion bonus.
  static const int perfectWeek = 75;

  /// Streak milestone bonus.
  static const int streakBonus = 20;

  /// Achievement unlock reward.
  static const int achievement = 100;

  /// Daily login reward (future).
  static const int dailyLogin = 5;
}
