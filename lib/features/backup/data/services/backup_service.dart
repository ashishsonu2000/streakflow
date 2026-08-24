import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';
import '../../../profile/domain/models/user_profile.dart';

import '../../domain/models/app_backup.dart';

class BackupService {
  const BackupService();

  Future<void> export({
    required UserProfile profile,
    required List<Habit> habits,
    required List<HabitLog> logs,
  }) async {
    final backup = AppBackup(
      version: '1.0.0',
      exportedAt: DateTime.now(),
      profile: _profileToJson(profile),
      habits: habits
          .map<Map<String, dynamic>>(
        _habitToJson,
      )
          .toList(),
      logs: logs
          .map<Map<String, dynamic>>(
        _logToJson,
      )
          .toList(),
    );

    final directory =
    await getTemporaryDirectory();

    final file = File(
      '${directory.path}/streak_backup.json',
    );

    await file.writeAsString(
      const JsonEncoder.withIndent(
        '  ',
      ).convert(
        backup.toJson(),
      ),
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            file.path,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _profileToJson(
      UserProfile profile,
      ) {
    return {
      'name': profile.name,
      'notificationsEnabled':
      profile.notificationsEnabled,
      'onboardingCompleted':
      profile.onboardingCompleted,
      'goals': profile.goals,
      'themeMode':
      profile.themeMode.name,
    };
  }

  Map<String, dynamic> _habitToJson(
      Habit habit,
      ) {
    return {
      'id': habit.id,
      'title': habit.title,
      'description':
      habit.description,
      'category':
      habit.category.name,
      'frequency':
      habit.frequency.name,
      'iconCodePoint':
      habit.iconCodePoint,
      'colorValue':
      habit.colorValue,
      'targetPerDay':
      habit.targetPerDay,
      'currentStreak':
      habit.currentStreak,
      'bestStreak':
      habit.bestStreak,
      'totalCompleted':
      habit.totalCompleted,
      'xp': habit.xp,
      'reminderEnabled':
      habit.reminderEnabled,
      'reminderHour':
      habit.reminderHour,
      'reminderMinute':
      habit.reminderMinute,
      'archived':
      habit.archived,
      'createdAt':
      habit.createdAt
          .toIso8601String(),
      'updatedAt':
      habit.updatedAt
          .toIso8601String(),
      'lastCompletedDate':
      habit.lastCompletedDate
          ?.toIso8601String(),
      'completedToday':
      habit.completedToday,
      'estimatedDurationMinutes':
      habit
          .estimatedDurationMinutes,
      'difficulty':
      habit.difficulty.name,
      'xpReward':
      habit.xpReward,
    };
  }


  Map<String, dynamic> _logToJson(
      HabitLog log,
      ) {
    return {
      'id': log.id,
      'habitId': log.habitId,
      'date': log.date.toIso8601String(),
      'status': log.status.name,
      'completedAt':
      log.completedAt?.toIso8601String(),
      'durationMinutes':
      log.durationMinutes,
      'notes': log.notes,
      'xpEarned': log.xpEarned,
      'mood': log.mood?.name,
    };
  }
}