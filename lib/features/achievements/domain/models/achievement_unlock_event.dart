import 'achievement.dart';

class AchievementUnlockEvent {
  const AchievementUnlockEvent({
    required this.achievement,
  });

  final Achievement achievement;
}