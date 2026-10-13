import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/shared_preferences_provider.dart';

/// Overridable in tests.
final feedbackPromptClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});

/// Whether the dashboard shows the "What should I improve?" card.
///
/// It appears once the app has been in use for [firstDelay], and again
/// [repeatDelay] after the user last sent feedback or closed it, so
/// testers are asked a few times without being nagged daily.
class FeedbackPromptNotifier extends Notifier<bool> {
  static const firstSeenKey = 'feedback_prompt_first_seen_v1';
  static const lastActionKey = 'feedback_prompt_last_action_v1';

  static const firstDelay = Duration(days: 2);
  static const repeatDelay = Duration(days: 7);

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (prefs == null) {
      return false;
    }

    final now = ref.watch(feedbackPromptClockProvider)();

    final firstSeenMs = prefs.getInt(firstSeenKey);
    if (firstSeenMs == null) {
      prefs.setInt(firstSeenKey, now.millisecondsSinceEpoch);
      return false;
    }

    final firstSeen = DateTime.fromMillisecondsSinceEpoch(firstSeenMs);
    if (now.difference(firstSeen) < firstDelay) {
      return false;
    }

    final lastActionMs = prefs.getInt(lastActionKey);
    if (lastActionMs == null) {
      return true;
    }

    final lastAction = DateTime.fromMillisecondsSinceEpoch(lastActionMs);
    return now.difference(lastAction) >= repeatDelay;
  }

  /// Hides the card until [repeatDelay] has passed. Called both when
  /// feedback is sent and when the card is closed.
  Future<void> snooze() async {
    state = false;
    final now = ref.read(feedbackPromptClockProvider)();
    await ref
        .read(sharedPreferencesProvider)
        ?.setInt(lastActionKey, now.millisecondsSinceEpoch);
  }
}

final feedbackPromptProvider =
    NotifierProvider<FeedbackPromptNotifier, bool>(
  FeedbackPromptNotifier.new,
);
