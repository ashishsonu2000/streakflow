import 'package:audioplayers/audioplayers.dart';

class AchievementSoundService {
  final AudioPlayer _player =
  AudioPlayer();

  Future<void> play() async {
    await _player.play(
      AssetSource(
        'sounds/achievement.mp3',
      ),
    );
  }
}