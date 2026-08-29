import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/data/entities/habit_log_entity.dart';
import 'package:streak_calculator_flutter/features/habits/domain/calculators/streak_calculator.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';

void main() {
  group('StreakCalculator', () {
    // ===============================================================
    // EMPTY
    // ===============================================================

    test('returns zero for empty logs', () {
      final result = StreakCalculator.calculate([]);

      expect(result.currentStreak, 0);
      expect(result.longestStreak, 0);
      expect(result.completedDays, 0);
      expect(result.perfectDays, 0);
    });

    // ===============================================================
    // SINGLE COMPLETION
    // ===============================================================

    test('single completion today creates a one-day streak', () {
      final today = _dateOnly(DateTime.now());

      final logs = [
        _completedLog(today),
      ];

      final result = StreakCalculator.calculate(logs);

      expect(result.currentStreak, 1);
      expect(result.longestStreak, 1);
      expect(result.completedDays, 1);
      expect(result.perfectDays, 1);
    });

    // ===============================================================
    // CONSECUTIVE DAYS
    // ===============================================================

    test('three consecutive days create a three-day streak', () {
      final today = _dateOnly(DateTime.now());

      final logs = [
        _completedLog(
          today.subtract(
            const Duration(days: 2),
          ),
        ),
        _completedLog(
          today.subtract(
            const Duration(days: 1),
          ),
        ),
        _completedLog(today),
      ];

      final result = StreakCalculator.calculate(logs);

      expect(result.currentStreak, 3);
      expect(result.longestStreak, 3);
      expect(result.completedDays, 3);
      expect(result.perfectDays, 3);
    });

    // ===============================================================
    // YESTERDAY
    // ===============================================================

    test(
      'yesterday completion is accepted as current streak',
          () {
        final today = _dateOnly(DateTime.now());

        final yesterday = today.subtract(
          const Duration(days: 1),
        );

        final logs = [
          _completedLog(yesterday),
        ];

        final result =
        StreakCalculator.calculate(logs);

        expect(result.currentStreak, 1);
        expect(result.longestStreak, 1);
        expect(result.completedDays, 1);
      },
    );

    // ===============================================================
    // MISSED DAY
    // ===============================================================

    test('a gap breaks the current streak', () {
      final today = _dateOnly(DateTime.now());

      final logs = [
        // Older two-day streak.
        _completedLog(
          today.subtract(
            const Duration(days: 4),
          ),
        ),
        _completedLog(
          today.subtract(
            const Duration(days: 3),
          ),
        ),

        // Gap on day -2.

        // Latest completion.
        _completedLog(
          today.subtract(
            const Duration(days: 1),
          ),
        ),
      ];

      final result = StreakCalculator.calculate(logs);

      expect(result.currentStreak, 1);

      // Historical longest streak remains 2.
      expect(result.longestStreak, 2);

      expect(result.completedDays, 3);
    });

    // ===============================================================
    // BEST STREAK
    // ===============================================================

    test('longest streak is calculated independently of current streak',
            () {
          final today = _dateOnly(DateTime.now());

          final logs = [
            // Historical five-day streak.
            _completedLog(
              today.subtract(
                const Duration(days: 10),
              ),
            ),
            _completedLog(
              today.subtract(
                const Duration(days: 9),
              ),
            ),
            _completedLog(
              today.subtract(
                const Duration(days: 8),
              ),
            ),
            _completedLog(
              today.subtract(
                const Duration(days: 7),
              ),
            ),
            _completedLog(
              today.subtract(
                const Duration(days: 6),
              ),
            ),

            // Current streak is only one day.
            _completedLog(today),
          ];

          final result = StreakCalculator.calculate(logs);

          expect(result.currentStreak, 1);
          expect(result.longestStreak, 5);
          expect(result.completedDays, 6);
        });

    // ===============================================================
    // DUPLICATE SAME DAY
    // ===============================================================

    test('duplicate logs on the same day count as one completed day',
            () {
          final today = _dateOnly(DateTime.now());

          final logs = [
            _completedLog(today),
            _completedLog(
              DateTime(
                today.year,
                today.month,
                today.day,
                10,
              ),
            ),
            _completedLog(
              DateTime(
                today.year,
                today.month,
                today.day,
                20,
              ),
            ),
          ];

          final result = StreakCalculator.calculate(logs);

          expect(result.completedDays, 1);
          expect(result.perfectDays, 1);
          expect(result.currentStreak, 1);
          expect(result.longestStreak, 1);
        });

    // ===============================================================
    // INCOMPLETE LOGS
    // ===============================================================

    test('non-completed logs are ignored', () {
      final today = _dateOnly(DateTime.now());

      final completed = _completedLog(today);

      final incomplete = HabitLogEntity()
        ..date = today.subtract(
          const Duration(days: 1),
        )
        ..habitId = 'test-habit'
        ..status = CompletionStatus.pending;

      final logs = [
        completed,
        incomplete,
      ];

      final result = StreakCalculator.calculate(logs);

      expect(result.completedDays, 1);
      expect(result.perfectDays, 1);
      expect(result.currentStreak, 1);
      expect(result.longestStreak, 1);
    });

    // ===============================================================
    // START DATE
    // ===============================================================

    test('logs before start date are ignored', () {
      final today = _dateOnly(DateTime.now());

      final startDate = today.subtract(
        const Duration(days: 1),
      );

      final logs = [
        // Before start date.
        _completedLog(
          today.subtract(
            const Duration(days: 3),
          ),
        ),

        // Valid completion.
        _completedLog(
          today.subtract(
            const Duration(days: 1),
          ),
        ),

        _completedLog(today),
      ];

      final result = StreakCalculator.calculate(
        logs,
        startDate: startDate,
      );

      expect(result.completedDays, 2);
      expect(result.perfectDays, 2);
      expect(result.currentStreak, 2);
      expect(result.longestStreak, 2);
    });

    // ===============================================================
    // END DATE
    // ===============================================================

    test('logs after end date are ignored', () {
      final today = _dateOnly(DateTime.now());

      final endDate = today.subtract(
        const Duration(days: 1),
      );

      final logs = [
        // Valid.
        _completedLog(
          today.subtract(
            const Duration(days: 2),
          ),
        ),

        _completedLog(endDate),

        // After end date.
        _completedLog(today),
      ];

      final result = StreakCalculator.calculate(
        logs,
        endDate: endDate,
      );

      expect(result.completedDays, 2);
      expect(result.perfectDays, 2);
      expect(result.currentStreak, 2);
      expect(result.longestStreak, 2);
    });

    // ===============================================================
    // INVALID SCHEDULE
    // ===============================================================

    test('invalid schedule returns zero result', () {
      final today = _dateOnly(DateTime.now());

      final startDate = today;

      final endDate = today.subtract(
        const Duration(days: 1),
      );

      final logs = [
        _completedLog(today),
      ];

      final result = StreakCalculator.calculate(
        logs,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result.currentStreak, 0);
      expect(result.longestStreak, 0);
      expect(result.completedDays, 0);
      expect(result.perfectDays, 0);
    });

    // ===============================================================
    // BEFORE START DATE
    // ===============================================================

    test(
      'current streak is zero when habit has not started yet',
          () {
        final today = _dateOnly(DateTime.now());

        final startDate = today.add(
          const Duration(days: 2),
        );

        final logs = [
          _completedLog(today),
        ];

        final result = StreakCalculator.calculate(
          logs,
          startDate: startDate,
        );

        expect(result.currentStreak, 0);
        expect(result.completedDays, 0);
        expect(result.longestStreak, 0);
      },
    );

    // ===============================================================
    // ENDED HABIT
    // ===============================================================

    test(
      'current streak uses end date as anchor for ended habit',
          () {
        final today = _dateOnly(DateTime.now());

        final endDate = today.subtract(
          const Duration(days: 3),
        );

        final logs = [
          _completedLog(
            endDate.subtract(
              const Duration(days: 2),
            ),
          ),
          _completedLog(
            endDate.subtract(
              const Duration(days: 1),
            ),
          ),
          _completedLog(endDate),
        ];

        final result = StreakCalculator.calculate(
          logs,
          endDate: endDate,
        );

        expect(result.currentStreak, 3);
        expect(result.longestStreak, 3);
        expect(result.completedDays, 3);
      },
    );

    // ===============================================================
    // DATE NORMALIZATION
    // ===============================================================

    test('different times on consecutive days still count correctly',
            () {
          final today = _dateOnly(DateTime.now());

          final logs = [
            _completedLog(
              DateTime(
                today.year,
                today.month,
                today.day - 1,
                23,
                59,
              ),
            ),
            _completedLog(
              DateTime(
                today.year,
                today.month,
                today.day,
                1,
                5,
              ),
            ),
          ];

          final result = StreakCalculator.calculate(logs);

          expect(result.currentStreak, 2);
          expect(result.longestStreak, 2);
          expect(result.completedDays, 2);
        });
  });
}

// =====================================================================
// TEST HELPERS
// =====================================================================

HabitLogEntity _completedLog(
    DateTime date,
    ) {
  return HabitLogEntity()
    ..date = date
    ..habitId = 'test-habit'
    ..status = CompletionStatus.completed;
}

DateTime _dateOnly(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
  );
}