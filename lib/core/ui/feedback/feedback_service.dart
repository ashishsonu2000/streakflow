import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class FeedbackService {
  FeedbackService._();

  static final AudioPlayer _player = AudioPlayer();

  // =========================================================
  // 🔊 SOUND
  // =========================================================

  static Future<void> playXpSound() async {
    try {
      await _player.play(AssetSource('sounds/xp.mp3'));
    } catch (_) {}
  }

  static Future<void> playLevelUpSound() async {
    try {
      await _player.play(AssetSource('sounds/level_up.mp3'));
    } catch (_) {}
  }

  // =========================================================
  // 📳 HAPTICS (NO PLUGIN)
  // =========================================================

  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selection() {
    HapticFeedback.selectionClick();
  }

  static Future<void> celebrate() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    HapticFeedback.mediumImpact();
  }
}