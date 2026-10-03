import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import 'habit_repository_provider.dart';

/// Keeps stored streaks current as days pass.
///
/// Streaks are stored on each habit and otherwise only recalculated
/// when a habit is completed or undone, so a missed day would never
/// lower a card's streak. [refreshIfNewDay] recalculates them once per
/// calendar day: at app start and when the app returns to the
/// foreground on a new day (MainShell).
class StreakRefresher {
  StreakRefresher(this._ref, {DateTime Function()? now}) : _now = now;

  final Ref _ref;
  final DateTime Function()? _now;

  DateTime? _refreshedFor;
  Future<void>? _running;

  Future<void> refreshIfNewDay() {
    final now = _now?.call() ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_refreshedFor == today) {
      return Future.value();
    }

    return _running ??= _refresh(today);
  }

  Future<void> _refresh(DateTime today) async {
    try {
      await _ref.read(habitRepositoryProvider).refreshStreaks();
      _refreshedFor = today;
    } catch (error) {
      // Retried on the next start or resume.
      AppLogger.log('[Streaks] Refresh failed: $error');
    } finally {
      _running = null;
    }
  }
}

final streakRefresherProvider = Provider<StreakRefresher>(
  StreakRefresher.new,
);
