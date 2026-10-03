import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/services/habit_analytics_service.dart';

void main() {
  group('HabitAnalyticsService', () {
    // ===============================================================
    // EMPTY HABITS
    // ===============================================================

    test('totalXp returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.totalXp([]),
        0,
      );
    });

    test('totalCompleted returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.totalCompleted([]),
        0,
      );
    });

    test('currentStreak returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.currentStreak([]),
        0,
      );
    });

    test('bestStreak returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.bestStreak([]),
        0,
      );
    });

    test('activeHabits returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.activeHabits([]),
        0,
      );
    });

    test('archivedHabits returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.archivedHabits([]),
        0,
      );
    });

    test('completedToday returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.completedToday([]),
        0,
      );
    });

    test('pendingToday returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.pendingToday([]),
        0,
      );
    });

    test('weeklyCompletion returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.weeklyCompletion([]),
        0,
      );
    });

    test('monthlyCompletion returns zero for empty habits', () {
      expect(
        HabitAnalyticsService.monthlyCompletion([]),
        0,
      );
    });

    test('successRate returns zero when there are no completions', () {
      expect(
        HabitAnalyticsService.successRate([]),
        0,
      );
    });

    // ===============================================================
    // TOTAL XP
    // ===============================================================

    test('totalXp sums XP from all habits', () {
      final habits = [
        _habit(
          id: 'habit-1',
          xp: 5,
        ),
        _habit(
          id: 'habit-2',
          xp: 10,
        ),
        _habit(
          id: 'habit-3',
          xp: 25,
        ),
      ];

      expect(
        HabitAnalyticsService.totalXp(habits),
        40,
      );
    });

    // ===============================================================
    // TOTAL COMPLETED
    // ===============================================================

    test('totalCompleted sums completed counts', () {
      final habits = [
        _habit(
          id: 'habit-1',
          totalCompleted: 2,
        ),
        _habit(
          id: 'habit-2',
          totalCompleted: 5,
        ),
        _habit(
          id: 'habit-3',
          totalCompleted: 3,
        ),
      ];

      expect(
        HabitAnalyticsService.totalCompleted(habits),
        10,
      );
    });

    // ===============================================================
    // CURRENT STREAK
    // ===============================================================

    test('currentStreak sums current streaks', () {
      final habits = [
        _habit(
          id: 'habit-1',
          currentStreak: 3,
        ),
        _habit(
          id: 'habit-2',
          currentStreak: 5,
        ),
        _habit(
          id: 'habit-3',
          currentStreak: 2,
        ),
      ];

      expect(
        HabitAnalyticsService.currentStreak(habits),
        10,
      );
    });

    // ===============================================================
    // BEST STREAK
    // ===============================================================

    test('bestStreak sums best streaks', () {
      final habits = [
        _habit(
          id: 'habit-1',
          bestStreak: 7,
        ),
        _habit(
          id: 'habit-2',
          bestStreak: 10,
        ),
        _habit(
          id: 'habit-3',
          bestStreak: 4,
        ),
      ];

      expect(
        HabitAnalyticsService.bestStreak(habits),
        21,
      );
    });

    // ===============================================================
    // ACTIVE HABITS
    // ===============================================================

    test('activeHabits counts non-archived habits', () {
      final habits = [
        _habit(
          id: 'habit-1',
          archived: false,
        ),
        _habit(
          id: 'habit-2',
          archived: true,
        ),
        _habit(
          id: 'habit-3',
          archived: false,
        ),
        _habit(
          id: 'habit-4',
          archived: false,
        ),
      ];

      expect(
        HabitAnalyticsService.activeHabits(habits),
        3,
      );
    });

    // ===============================================================
    // ARCHIVED HABITS
    // ===============================================================

    test('archivedHabits counts archived habits', () {
      final habits = [
        _habit(
          id: 'habit-1',
          archived: false,
        ),
        _habit(
          id: 'habit-2',
          archived: true,
        ),
        _habit(
          id: 'habit-3',
          archived: true,
        ),
        _habit(
          id: 'habit-4',
          archived: false,
        ),
      ];

      expect(
        HabitAnalyticsService.archivedHabits(habits),
        2,
      );
    });

    // ===============================================================
    // COMPLETED TODAY
    // ===============================================================

    test('completedToday counts completed habits', () {
      final habits = [
        _habit(
          id: 'habit-1',
          completedToday: true,
        ),
        _habit(
          id: 'habit-2',
          completedToday: false,
        ),
        _habit(
          id: 'habit-3',
          completedToday: true,
        ),
      ];

      expect(
        HabitAnalyticsService.completedToday(habits),
        2,
      );
    });

    // ===============================================================
    // PENDING TODAY
    // ===============================================================

    test('pendingToday counts active incomplete habits', () {
      final habits = [
        _habit(
          id: 'habit-1',
          completedToday: false,
          archived: false,
        ),
        _habit(
          id: 'habit-2',
          completedToday: true,
          archived: false,
        ),
        _habit(
          id: 'habit-3',
          completedToday: false,
          archived: true,
        ),
        _habit(
          id: 'habit-4',
          completedToday: false,
          archived: false,
        ),
      ];

      expect(
        HabitAnalyticsService.pendingToday(habits),
        2,
      );
    });

    // ===============================================================
    // WEEKLY COMPLETION
    // ===============================================================

    test('weeklyCompletion calculates percentage from completed today',
            () {
          final habits = [
            _habit(
              id: 'habit-1',
              completedToday: true,
            ),
            _habit(
              id: 'habit-2',
              completedToday: true,
            ),
            _habit(
              id: 'habit-3',
              completedToday: false,
            ),
            _habit(
              id: 'habit-4',
              completedToday: false,
            ),
          ];

          expect(
            HabitAnalyticsService.weeklyCompletion(habits),
            50,
          );
        });

    test('weeklyCompletion returns 100 when all habits are completed today',
            () {
          final habits = [
            _habit(
              id: 'habit-1',
              completedToday: true,
            ),
            _habit(
              id: 'habit-2',
              completedToday: true,
            ),
          ];

          expect(
            HabitAnalyticsService.weeklyCompletion(habits),
            100,
          );
        });

    // ===============================================================
    // MONTHLY COMPLETION
    // ===============================================================

    test(
      'monthlyCompletion currently matches weeklyCompletion',
          () {
        final habits = [
          _habit(
            id: 'habit-1',
            completedToday: true,
          ),
          _habit(
            id: 'habit-2',
            completedToday: false,
          ),
          _habit(
            id: 'habit-3',
            completedToday: false,
          ),
          _habit(
            id: 'habit-4',
            completedToday: false,
          ),
        ];

        final weekly =
        HabitAnalyticsService.weeklyCompletion(
          habits,
        );

        final monthly =
        HabitAnalyticsService.monthlyCompletion(
          habits,
        );

        expect(
          weekly,
          25,
        );

        expect(
          monthly,
          weekly,
        );
      },
    );

    // ===============================================================
    // SUCCESS RATE
    // ===============================================================

    test('successRate calculates completed today against total completed',
            () {
          final habits = [
            _habit(
              id: 'habit-1',
              completedToday: true,
              totalCompleted: 2,
            ),
            _habit(
              id: 'habit-2',
              completedToday: true,
              totalCompleted: 4,
            ),
          ];

          // completedToday = 2
          // totalCompleted = 6
          // 2 / 6 * 100 = 33.333...
          expect(
            HabitAnalyticsService.successRate(habits),
            closeTo(33.3333, 0.001),
          );
        });

    // ===============================================================
    // ARCHIVED HABITS + PENDING
    // ===============================================================

    test('archived habits are excluded from pendingToday', () {
      final habits = [
        _habit(
          id: 'active-pending',
          archived: false,
          completedToday: false,
        ),
        _habit(
          id: 'archived-pending',
          archived: true,
          completedToday: false,
        ),
      ];

      expect(
        HabitAnalyticsService.pendingToday(habits),
        1,
      );
    });

    // ===============================================================
    // MIXED ANALYTICS
    // ===============================================================

    test('calculates multiple dashboard metrics correctly', () {
      final habits = [
        _habit(
          id: 'running',
          xp: 20,
          currentStreak: 4,
          bestStreak: 8,
          totalCompleted: 10,
          completedToday: true,
          archived: false,
        ),
        _habit(
          id: 'reading',
          xp: 15,
          currentStreak: 2,
          bestStreak: 5,
          totalCompleted: 6,
          completedToday: false,
          archived: false,
        ),
        _habit(
          id: 'old-habit',
          xp: 30,
          currentStreak: 0,
          bestStreak: 12,
          totalCompleted: 20,
          completedToday: false,
          archived: true,
        ),
      ];

      expect(
        HabitAnalyticsService.totalXp(habits),
        65,
      );

      expect(
        HabitAnalyticsService.totalCompleted(habits),
        36,
      );

      expect(
        HabitAnalyticsService.currentStreak(habits),
        6,
      );

      expect(
        HabitAnalyticsService.bestStreak(habits),
        25,
      );

      expect(
        HabitAnalyticsService.activeHabits(habits),
        2,
      );

      expect(
        HabitAnalyticsService.archivedHabits(habits),
        1,
      );

      expect(
        HabitAnalyticsService.completedToday(habits),
        1,
      );

      expect(
        HabitAnalyticsService.pendingToday(habits),
        1,
      );

      expect(
        HabitAnalyticsService.weeklyCompletion(habits),
        closeTo(33.3333, 0.001),
      );
    });
  });
}

// =====================================================================
// TEST HABIT FACTORY
// =====================================================================

Habit _habit({
  required String id,
  String title = 'Test Habit',
  int xp = 0,
  int currentStreak = 0,
  int bestStreak = 0,
  int totalCompleted = 0,
  bool completedToday = false,
  bool archived = false,
}) {
  final now = DateTime.now();

  return Habit(
    id: id,
    title: title,
    createdAt: now,
    updatedAt: now,
    startDate: DateTime(
      now.year,
      now.month,
      now.day,
    ),
    xp: xp,
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    totalCompleted: totalCompleted,
    completedToday: completedToday,
    archived: archived,
  );
}