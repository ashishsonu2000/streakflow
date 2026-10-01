import '../../../habits/domain/enums/completion_status.dart';
import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/enums/mood_type.dart';
import '../../../habits/domain/models/difficulty.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_category.dart';
import '../../../habits/domain/models/habit_log.dart';
import '../../../profile/domain/models/app_theme_mode.dart';
import '../../../profile/domain/models/user_profile.dart';

/// The backup file is not a StreakFlow backup (or is too damaged to use).
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// Profile fields kept in a backup.
class BackupProfile {
  const BackupProfile({
    required this.name,
    required this.goals,
    required this.notificationsEnabled,
    required this.themeMode,
  });

  final String name;
  final List<String> goals;
  final bool notificationsEnabled;
  final AppThemeMode themeMode;
}

/// A decoded backup, ready to restore.
class BackupContents {
  const BackupContents({
    required this.formatVersion,
    required this.exportedAt,
    required this.profile,
    required this.habits,
    required this.logs,
    required this.skippedHabits,
    required this.skippedLogs,
  });

  /// 1 = before schedule fields were exported (StreakFlow 1.0.0+3/4).
  final int formatVersion;
  final DateTime? exportedAt;
  final BackupProfile? profile;
  final List<Habit> habits;
  final List<HabitLog> logs;

  /// Records that were damaged or duplicated and left out.
  final int skippedHabits;

  /// Logs that were damaged or belong to no habit in the backup.
  final int skippedLogs;

  int get activeHabitCount => habits.where((h) => !h.archived).length;
}

/// Reads and writes StreakFlow backup files (JSON).
///
/// Pure (no IO), so the format is unit tested directly.
///
/// Format history:
///   1: habits without startDate, endDate, weeklyDays or monthlyDay.
///      Restored with fallbacks (start = creation date; weekly habits on
///      their start weekday; monthly habits on their start day).
///   2: complete habit schedule; `formatVersion` field.
abstract final class BackupCodec {
  static const formatVersion = 2;

  // =========================================================
  // Encode
  // =========================================================

  static Map<String, dynamic> encode({
    required UserProfile profile,
    required List<Habit> habits,
    required List<HabitLog> logs,
    required DateTime exportedAt,
  }) {
    return {
      'version': '1.0.0',
      'formatVersion': formatVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'profile': {
        'name': profile.name,
        'notificationsEnabled': profile.notificationsEnabled,
        'onboardingCompleted': profile.onboardingCompleted,
        'goals': profile.goals,
        'themeMode': profile.themeMode.name,
      },
      'habits': [for (final habit in habits) _habitToJson(habit)],
      'logs': [for (final log in logs) _logToJson(log)],
    };
  }

  static Map<String, dynamic> _habitToJson(Habit habit) {
    return {
      'id': habit.id,
      'title': habit.title,
      'description': habit.description,
      'category': habit.category.name,
      'frequency': habit.frequency.name,
      'iconCodePoint': habit.iconCodePoint,
      'colorValue': habit.colorValue,
      'targetPerDay': habit.targetPerDay,
      'currentStreak': habit.currentStreak,
      'bestStreak': habit.bestStreak,
      'totalCompleted': habit.totalCompleted,
      'xp': habit.xp,
      'reminderEnabled': habit.reminderEnabled,
      'reminderHour': habit.reminderHour,
      'reminderMinute': habit.reminderMinute,
      'additionalReminderMinutes': habit.additionalReminderMinutes,
      'archived': habit.archived,
      'createdAt': habit.createdAt.toIso8601String(),
      'updatedAt': habit.updatedAt.toIso8601String(),
      'lastCompletedDate': habit.lastCompletedDate?.toIso8601String(),
      'startDate': habit.startDate.toIso8601String(),
      'endDate': habit.endDate?.toIso8601String(),
      'weeklyDays': habit.weeklyDays,
      'monthlyDay': habit.monthlyDay,
      'estimatedDurationMinutes': habit.estimatedDurationMinutes,
      'difficulty': habit.difficulty.name,
      'xpReward': habit.xpReward,
    };
  }

  static Map<String, dynamic> _logToJson(HabitLog log) {
    return {
      'id': log.id,
      'habitId': log.habitId,
      'date': log.date.toIso8601String(),
      'status': log.status.name,
      'completedAt': log.completedAt?.toIso8601String(),
      'durationMinutes': log.durationMinutes,
      'notes': log.notes,
      'xpEarned': log.xpEarned,
      'mood': log.mood?.name,
    };
  }

  // =========================================================
  // Decode
  // =========================================================

  /// Throws [BackupFormatException] when [json] is not a backup.
  /// Individual damaged records are skipped and counted instead.
  static BackupContents decode(Object? json) {
    if (json is! Map) {
      throw const BackupFormatException('Not a StreakFlow backup file.');
    }

    final rawHabits = json['habits'];
    final rawLogs = json['logs'];

    if (rawHabits is! List || rawLogs is! List) {
      throw const BackupFormatException(
        'Not a StreakFlow backup file (no habits or history).',
      );
    }

    final version = _int(json['formatVersion']) ?? 1;
    if (version > formatVersion) {
      throw const BackupFormatException(
        'This backup was made by a newer version of StreakFlow. '
        'Update the app to restore it.',
      );
    }

    final habits = <Habit>[];
    final ids = <String>{};
    var skippedHabits = 0;

    for (final raw in rawHabits) {
      final habit = raw is Map ? _habitFromJson(raw) : null;
      if (habit == null || !ids.add(habit.id)) {
        skippedHabits++;
        continue;
      }
      habits.add(habit);
    }

    final logs = <HabitLog>[];
    var skippedLogs = 0;

    for (final raw in rawLogs) {
      final log = raw is Map ? _logFromJson(raw) : null;
      if (log == null || !ids.contains(log.habitId)) {
        skippedLogs++;
        continue;
      }
      logs.add(log);
    }

    final profile = json['profile'];

    return BackupContents(
      formatVersion: version,
      exportedAt: _date(json['exportedAt']),
      profile: profile is Map ? _profileFromJson(profile) : null,
      habits: habits,
      logs: logs,
      skippedHabits: skippedHabits,
      skippedLogs: skippedLogs,
    );
  }

  static Habit? _habitFromJson(Map json) {
    final id = json['id'];
    final title = json['title'];
    final createdAt = _date(json['createdAt']);

    if (id is! String || id.isEmpty || title is! String || createdAt == null) {
      return null;
    }

    final frequency = _enum(
      HabitFrequency.values,
      json['frequency'],
      HabitFrequency.daily,
    );

    // Format 1 had no schedule fields: start on the creation date, so
    // weekly habits keep their start weekday (HabitScheduleService's
    // rule for habits without weekdays) and monthly habits their day.
    final startDate = _date(json['startDate']) ??
        DateTime(createdAt.year, createdAt.month, createdAt.day);

    final reminderHour = _int(json['reminderHour']);
    final reminderMinute = _int(json['reminderMinute']);

    return Habit(
      id: id,
      title: title,
      description: _string(json['description']),
      category: _enum(
        HabitCategory.values,
        json['category'],
        HabitCategory.personal,
      ),
      frequency: frequency,
      iconCodePoint: _int(json['iconCodePoint']) ?? 0,
      colorValue: _int(json['colorValue']) ?? 0,
      targetPerDay: _int(json['targetPerDay']) ?? 1,
      currentStreak: _int(json['currentStreak']) ?? 0,
      bestStreak: _int(json['bestStreak']) ?? 0,
      totalCompleted: _int(json['totalCompleted']) ?? 0,
      xp: _int(json['xp']) ?? 0,
      reminderEnabled: json['reminderEnabled'] == true &&
          reminderHour != null &&
          reminderMinute != null,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      additionalReminderMinutes: _intList(json['additionalReminderMinutes'])
          .where((m) => m >= 0 && m < 24 * 60)
          .toList(),
      archived: json['archived'] == true,
      createdAt: createdAt,
      updatedAt: _date(json['updatedAt']) ?? createdAt,
      lastCompletedDate: _date(json['lastCompletedDate']),
      startDate: startDate,
      endDate: _date(json['endDate']),
      weeklyDays:
          _intList(json['weeklyDays']).where((d) => d >= 1 && d <= 7).toList(),
      monthlyDay: _int(json['monthlyDay']) ?? startDate.day,
      estimatedDurationMinutes: _int(json['estimatedDurationMinutes']) ?? 15,
      difficulty: _enum(
        Difficulty.values,
        json['difficulty'],
        Difficulty.easy,
      ),
      xpReward: _int(json['xpReward']) ?? 5,
    );
  }

  static HabitLog? _logFromJson(Map json) {
    final habitId = json['habitId'];
    final date = _date(json['date']);

    if (habitId is! String || habitId.isEmpty || date == null) {
      return null;
    }

    final mood = json['mood'];

    return HabitLog(
      id: _string(json['id']),
      habitId: habitId,
      date: date,
      status: _enum(
        CompletionStatus.values,
        json['status'],
        CompletionStatus.completed,
      ),
      completedAt: _date(json['completedAt']),
      durationMinutes: _int(json['durationMinutes']) ?? 0,
      notes: _string(json['notes']),
      xpEarned: _int(json['xpEarned']) ?? 0,
      mood: mood == null ? null : _enumOrNull(MoodType.values, mood),
    );
  }

  static BackupProfile _profileFromJson(Map json) {
    return BackupProfile(
      name: _string(json['name']),
      goals: json['goals'] is List
          ? (json['goals'] as List).whereType<String>().toList()
          : const [],
      notificationsEnabled: json['notificationsEnabled'] != false,
      themeMode: _enum(
        AppThemeMode.values,
        json['themeMode'],
        AppThemeMode.system,
      ),
    );
  }

  // =========================================================
  // Tolerant field readers
  // =========================================================

  static String _string(Object? value) =>
      value is String ? value : (value?.toString() ?? '');

  static int? _int(Object? value) {
    if (value is int) return value;
    if (value is double && value == value.roundToDouble()) {
      return value.toInt();
    }
    return null;
  }

  static List<int> _intList(Object? value) => value is List
      ? value.map(_int).whereType<int>().toSet().toList()
      : const [];

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  static T _enum<T extends Enum>(List<T> values, Object? name, T fallback) =>
      _enumOrNull(values, name) ?? fallback;

  static T? _enumOrNull<T extends Enum>(List<T> values, Object? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
