import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/backup/domain/services/backup_codec.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/mood_type.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/difficulty.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_category.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/profile/domain/models/app_theme_mode.dart';
import 'package:streak_calculator_flutter/features/profile/domain/models/user_profile.dart';

final _created = DateTime(2026, 9, 1, 8, 30);

Habit _weekly() => Habit(
      id: 'weekly',
      title: 'Gym',
      description: 'Legs, "push" day',
      category: HabitCategory.fitness,
      frequency: HabitFrequency.weekly,
      iconCodePoint: 0xe5ca,
      colorValue: 0xFF4CAF50,
      targetPerDay: 2,
      currentStreak: 3,
      bestStreak: 7,
      totalCompleted: 20,
      xp: 200,
      reminderEnabled: true,
      reminderHour: 7,
      reminderMinute: 15,
      additionalReminderMinutes: const [720, 1260],
      createdAt: _created,
      updatedAt: DateTime(2026, 9, 20),
      lastCompletedDate: DateTime(2026, 9, 29),
      startDate: DateTime(2026, 9, 2),
      endDate: DateTime(2027, 1, 31),
      weeklyDays: const [1, 3, 5],
      estimatedDurationMinutes: 45,
      difficulty: Difficulty.hard,
      xpReward: 20,
    );

Habit _monthly() => Habit(
      id: 'monthly',
      title: 'Budget',
      frequency: HabitFrequency.monthly,
      monthlyDay: 28,
      archived: true,
      createdAt: _created,
      updatedAt: _created,
      startDate: DateTime(2026, 9, 1),
    );

HabitLog _log(String habitId, {MoodType? mood}) => HabitLog(
      id: '17',
      habitId: habitId,
      date: DateTime(2026, 9, 28),
      status: CompletionStatus.completed,
      completedAt: DateTime(2026, 9, 28, 7, 20),
      durationMinutes: 40,
      notes: 'felt good',
      xpEarned: 20,
      mood: mood,
    );

const _profile = UserProfile(
  name: 'Ashish',
  notificationsEnabled: true,
  onboardingCompleted: true,
  goals: ['Fitness', 'Focus'],
  themeMode: AppThemeMode.dark,
);

/// Encode, through real JSON text, and decode.
BackupContents _roundTrip(List<Habit> habits, List<HabitLog> logs) {
  final encoded = BackupCodec.encode(
    profile: _profile,
    habits: habits,
    logs: logs,
    exportedAt: DateTime(2026, 10, 1, 9),
  );
  return BackupCodec.decode(jsonDecode(jsonEncode(encoded)));
}

void main() {
  group('round trip', () {
    test('every habit field survives, including the schedule', () {
      final restored = _roundTrip([_weekly(), _monthly()], const []);
      final weekly = restored.habits.first;
      final original = _weekly();

      expect(restored.formatVersion, BackupCodec.formatVersion);
      expect(weekly.toString(), original.toString());
      expect(weekly.startDate, original.startDate);
      expect(weekly.endDate, original.endDate);
      expect(weekly.weeklyDays, [1, 3, 5]);
      expect(weekly.additionalReminderMinutes, [720, 1260]);
      expect(weekly.difficulty, Difficulty.hard);

      final monthly = restored.habits.last;
      expect(monthly.monthlyDay, 28);
      expect(monthly.archived, isTrue);
      expect(restored.activeHabitCount, 1);
    });

    test('logs and the profile survive', () {
      final restored = _roundTrip(
        [_weekly()],
        [_log('weekly', mood: MoodType.good)],
      );
      final log = restored.logs.single;

      expect(log.date, DateTime(2026, 9, 28));
      expect(log.completedAt, DateTime(2026, 9, 28, 7, 20));
      expect(log.durationMinutes, 40);
      expect(log.notes, 'felt good');
      expect(log.xpEarned, 20);
      expect(log.mood, MoodType.good);

      expect(restored.profile!.name, 'Ashish');
      expect(restored.profile!.goals, ['Fitness', 'Focus']);
      expect(restored.profile!.themeMode, AppThemeMode.dark);
      expect(restored.exportedAt, DateTime(2026, 10, 1, 9));
    });
  });

  group('backups from earlier versions (format 1)', () {
    Map<String, dynamic> v1Habit(Map<String, dynamic> extra) => {
          'id': 'old',
          'title': 'Read',
          'frequency': 'weekly',
          'createdAt': '2026-09-03T10:00:00.000',
          'updatedAt': '2026-09-03T10:00:00.000',
          ...extra,
        };

    test('missing schedule fields fall back to the creation date', () {
      final restored = BackupCodec.decode({
        'version': '1.0.0',
        'habits': [v1Habit({})],
        'logs': [],
      });
      final habit = restored.habits.single;

      expect(restored.formatVersion, 1);
      expect(habit.startDate, DateTime(2026, 9, 3));
      expect(habit.endDate, isNull);
      // No weekdays: HabitScheduleService uses the start weekday.
      expect(habit.weeklyDays, isEmpty);
      expect(habit.monthlyDay, 3);
      expect(habit.additionalReminderMinutes, isEmpty);
    });

    test('unknown enum values fall back to defaults', () {
      final restored = BackupCodec.decode({
        'habits': [
          v1Habit({'category': 'gardening', 'difficulty': 'extreme'}),
        ],
        'logs': [
          {
            'habitId': 'old',
            'date': '2026-09-04T00:00:00.000',
            'status': 'teleported',
            'mood': 'confused',
          },
        ],
      });

      expect(restored.habits.single.category, HabitCategory.personal);
      expect(restored.habits.single.difficulty, Difficulty.easy);
      expect(restored.logs.single.status, CompletionStatus.completed);
      expect(restored.logs.single.mood, isNull);
    });
  });

  group('damaged files', () {
    test('not a backup at all', () {
      expect(() => BackupCodec.decode('hello'),
          throwsA(isA<BackupFormatException>()));
      expect(() => BackupCodec.decode({'name': 'x'}),
          throwsA(isA<BackupFormatException>()));
      expect(() => BackupCodec.decode([1, 2]),
          throwsA(isA<BackupFormatException>()));
    });

    test('from a newer app version', () {
      expect(
        () => BackupCodec.decode({
          'formatVersion': BackupCodec.formatVersion + 1,
          'habits': [],
          'logs': [],
        }),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('damaged, duplicate and orphan records are skipped and counted',
        () {
      final good = _roundTrip([_weekly()], const []);
      // Through JSON text, like a real file (untyped lists).
      final file = jsonDecode(jsonEncode(BackupCodec.encode(
        profile: _profile,
        habits: [_weekly(), _weekly()], // duplicate id
        logs: [_log('weekly'), _log('deleted-habit')], // orphan log
        exportedAt: DateTime(2026, 10, 1),
      ))) as Map<String, dynamic>;
      (file['habits'] as List).add({'title': 'no id'});
      (file['habits'] as List).add('not even a map');
      (file['logs'] as List).add({'habitId': 'weekly'}); // no date

      final restored = BackupCodec.decode(file);

      expect(restored.habits.map((h) => h.id), ['weekly']);
      expect(restored.skippedHabits, 3);
      expect(restored.logs, hasLength(1));
      expect(restored.skippedLogs, 2);
      expect(good.skippedHabits, 0);
    });

    test('a reminder flag without a time is not restored as enabled', () {
      final restored = BackupCodec.decode({
        'habits': [
          {
            'id': 'h',
            'title': 'x',
            'createdAt': '2026-09-03T10:00:00.000',
            'reminderEnabled': true,
          },
        ],
        'logs': [],
      });

      expect(restored.habits.single.reminderEnabled, isFalse);
    });
  });
}
