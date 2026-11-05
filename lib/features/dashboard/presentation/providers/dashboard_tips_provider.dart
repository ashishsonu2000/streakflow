import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/shared_preferences_provider.dart';

/// First-use tips shown one at a time on the dashboard.
const dashboardTips = <String>[
  'Tap the box next to a habit to mark it done for today. '
      'Tap it again to undo.',
  'Tap a habit to see its streak, history and reminder.',
  'Habits with a daily target, like 8 glasses of water, count one step '
      'per tap. See the steps (3/8) in the Habits tab.',
  'Tap a day in the calendar to open it in the Calendar tab.',
  'Achievements, reminders and backups are in Settings.',
];

/// Index of the tip to show, or null when the tips card is hidden.
///
/// Tips start on first launch and stay until the user closes the card
/// or reads the last tip. Progress survives restarts.
class DashboardTipsNotifier extends Notifier<int?> {
  static const indexKey = 'dashboard_tips_index_v1';
  static const doneKey = 'dashboard_tips_done_v1';

  @override
  int? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (prefs == null) return null;
    if (prefs.getBool(doneKey) ?? false) return null;

    final index = prefs.getInt(indexKey) ?? 0;
    if (index < 0 || index >= dashboardTips.length) return null;
    return index;
  }

  /// Shows the next tip, or hides the card after the last one.
  Future<void> next() async {
    final current = state;
    if (current == null) return;
    if (current >= dashboardTips.length - 1) {
      await dismiss();
      return;
    }
    state = current + 1;
    await ref.read(sharedPreferencesProvider)?.setInt(indexKey, current + 1);
  }

  /// Hides the tips for good.
  Future<void> dismiss() async {
    state = null;
    await ref.read(sharedPreferencesProvider)?.setBool(doneKey, true);
  }
}

final dashboardTipsProvider =
    NotifierProvider<DashboardTipsNotifier, int?>(
  DashboardTipsNotifier.new,
);
