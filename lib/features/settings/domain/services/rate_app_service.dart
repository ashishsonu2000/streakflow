import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Rating StreakFlow, from Settings or after a streak milestone.
class RateAppService {
  RateAppService({InAppReview? review})
      : _review = review ?? InAppReview.instance;

  final InAppReview _review;

  /// Stores that the milestone prompt was already requested.
  static const milestonePromptKey = 'rate_prompt_milestone_v1';

  /// Streak length (days) that triggers the one-time review prompt.
  static const milestoneStreak = 7;

  /// Settings → "Rate StreakFlow". Opens the store page, which always
  /// shows something; the in-app sheet may silently do nothing once
  /// Google's quota is used up, so a button shouldn't rely on it.
  ///
  /// iOS has no App Store ID yet, so it uses the system review sheet.
  Future<void> openStoreListing() async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        if (await _review.isAvailable()) {
          await _review.requestReview();
        }
        return;
      }
      await _review.openStoreListing();
    } catch (_) {
      // No store app (emulator without Play, etc.): nothing to open.
    }
  }

  /// Whether the milestone prompt should be requested now: the streak
  /// just went up and is at least [milestoneStreak], and it hasn't been
  /// requested before on this install.
  static bool shouldPromptForMilestone({
    required SharedPreferences? prefs,
    required int previousStreak,
    required int streak,
  }) {
    if (prefs == null) return false;
    if (prefs.getBool(milestonePromptKey) ?? false) return false;
    return streak > previousStreak && streak >= milestoneStreak;
  }

  /// Asks Google Play / the App Store to show the in-app review sheet
  /// once, after the user reaches a [milestoneStreak]-day streak.
  Future<void> promptForMilestone(SharedPreferences prefs) async {
    await prefs.setBool(milestonePromptKey, true);
    try {
      if (await _review.isAvailable()) {
        await _review.requestReview();
      }
    } catch (_) {
      // The review sheet is best effort.
    }
  }
}
