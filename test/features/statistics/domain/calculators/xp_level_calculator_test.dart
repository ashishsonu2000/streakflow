import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/calculators/xp_level_calculator.dart';


void main() {
  group('XPLevelCalculator', () {
    // ===============================================================
    // LEVEL 1
    // ===============================================================

    test('zero XP starts at level 1', () {
      final result =
      XPLevelCalculator.calculate(0);

      expect(result.level, 1);
      expect(result.previousLevelXp, 0);
      expect(result.nextLevelXp, 100);
      expect(result.progress, 0.0);
    });

    test('1 XP gives level 1 with 1 percent progress', () {
      final result =
      XPLevelCalculator.calculate(1);

      expect(result.level, 1);
      expect(result.previousLevelXp, 0);
      expect(result.nextLevelXp, 100);
      expect(result.progress, 0.01);
    });

    test('50 XP gives level 1 with 50 percent progress', () {
      final result =
      XPLevelCalculator.calculate(50);

      expect(result.level, 1);
      expect(result.previousLevelXp, 0);
      expect(result.nextLevelXp, 100);
      expect(result.progress, 0.5);
    });

    test('99 XP is still level 1', () {
      final result =
      XPLevelCalculator.calculate(99);

      expect(result.level, 1);
      expect(result.previousLevelXp, 0);
      expect(result.nextLevelXp, 100);
      expect(result.progress, 0.99);
    });

    // ===============================================================
    // LEVEL 2
    // ===============================================================

    test('100 XP starts level 2', () {
      final result =
      XPLevelCalculator.calculate(100);

      expect(result.level, 2);
      expect(result.previousLevelXp, 100);
      expect(result.nextLevelXp, 200);
      expect(result.progress, 0.0);
    });

    test('150 XP gives level 2 with 50 percent progress', () {
      final result =
      XPLevelCalculator.calculate(150);

      expect(result.level, 2);
      expect(result.previousLevelXp, 100);
      expect(result.nextLevelXp, 200);
      expect(result.progress, 0.5);
    });

    test('199 XP is still level 2', () {
      final result =
      XPLevelCalculator.calculate(199);

      expect(result.level, 2);
      expect(result.previousLevelXp, 100);
      expect(result.nextLevelXp, 200);
      expect(result.progress, 0.99);
    });

    // ===============================================================
    // LEVEL BOUNDARIES
    // ===============================================================

    test('200 XP starts level 3', () {
      final result =
      XPLevelCalculator.calculate(200);

      expect(result.level, 3);
      expect(result.previousLevelXp, 200);
      expect(result.nextLevelXp, 300);
      expect(result.progress, 0.0);
    });

    test('300 XP starts level 4', () {
      final result =
      XPLevelCalculator.calculate(300);

      expect(result.level, 4);
      expect(result.previousLevelXp, 300);
      expect(result.nextLevelXp, 400);
      expect(result.progress, 0.0);
    });

    test('1000 XP starts level 11', () {
      final result =
      XPLevelCalculator.calculate(1000);

      expect(result.level, 11);
      expect(result.previousLevelXp, 1000);
      expect(result.nextLevelXp, 1100);
      expect(result.progress, 0.0);
    });

    // ===============================================================
    // HIGH XP
    // ===============================================================

    test('1234 XP produces correct level and progress', () {
      final result =
      XPLevelCalculator.calculate(1234);

      expect(result.level, 13);
      expect(result.previousLevelXp, 1200);
      expect(result.nextLevelXp, 1300);

      expect(
        result.progress,
        closeTo(0.34, 0.000001),
      );
    });

    test('9999 XP produces correct level and progress', () {
      final result =
      XPLevelCalculator.calculate(9999);

      expect(result.level, 100);
      expect(result.previousLevelXp, 9900);
      expect(result.nextLevelXp, 10000);

      expect(
        result.progress,
        closeTo(0.99, 0.000001),
      );
    });

    // ===============================================================
    // PROGRESS RANGE
    // ===============================================================

    test('progress is always between zero and one', () {
      final testValues = [
        0,
        1,
        50,
        99,
        100,
        101,
        150,
        199,
        200,
        500,
        999,
        1000,
        1234,
        9999,
      ];

      for (final xp in testValues) {
        final result =
        XPLevelCalculator.calculate(xp);

        expect(
          result.progress,
          greaterThanOrEqualTo(0.0),
          reason:
          'Progress below zero for XP $xp',
        );

        expect(
          result.progress,
          lessThanOrEqualTo(1.0),
          reason:
          'Progress above one for XP $xp',
        );
      }
    });

    // ===============================================================
    // MONOTONIC LEVEL
    // ===============================================================

    test('increasing XP never decreases the level', () {
      var previousLevel = 1;

      for (var xp = 0;
      xp <= 2000;
      xp += 25) {
        final result =
        XPLevelCalculator.calculate(xp);

        expect(
          result.level,
          greaterThanOrEqualTo(
            previousLevel,
          ),
        );

        previousLevel = result.level;
      }
    });

    // ===============================================================
    // MONOTONIC PROGRESS WITHIN LEVEL
    // ===============================================================

    test('progress increases within the same level', () {
      final first =
      XPLevelCalculator.calculate(110);

      final second =
      XPLevelCalculator.calculate(130);

      final third =
      XPLevelCalculator.calculate(160);

      expect(first.level, 2);
      expect(second.level, 2);
      expect(third.level, 2);

      expect(
        second.progress,
        greaterThan(first.progress),
      );

      expect(
        third.progress,
        greaterThan(second.progress),
      );
    });
  });
}