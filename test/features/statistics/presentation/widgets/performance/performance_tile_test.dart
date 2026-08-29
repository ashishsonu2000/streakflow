import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/statistics/domain/models/habit_performance.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/performance/performance_tile.dart';

void main() {
  group('PerformanceTile', () {
    // ===============================================================
    // BASIC RENDERING
    // ===============================================================

    testWidgets(
      'renders habit title',
          (tester) async {
        final performance = _performance(
          title: 'Morning Exercise',
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('Morning Exercise'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders all metric labels',
          (tester) async {
        final performance = _performance();

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('Current'),
          findsOneWidget,
        );

        expect(
          find.text('Best'),
          findsOneWidget,
        );

        expect(
          find.text('XP'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETION PERCENTAGE
    // ===============================================================

    testWidgets(
      'displays completion percentage',
          (tester) async {
        final performance = _performance(
          completionRate: 0.75,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('75%'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'rounds completion percentage correctly',
          (tester) async {
        final performance = _performance(
          completionRate: 0.756,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('76%'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // PROGRESS INDICATOR
    // ===============================================================

    testWidgets(
      'renders progress indicator',
          (tester) async {
        final performance = _performance(
          completionRate: 0.65,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.byType(LinearProgressIndicator),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'uses completion rate for progress',
          (tester) async {
        final performance = _performance(
          completionRate: 0.65,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        final progress =
        tester.widget<LinearProgressIndicator>(
          find.byType(
            LinearProgressIndicator,
          ),
        );

        expect(
          progress.value,
          0.65,
        );
      },
    );

    testWidgets(
      'clamps progress below zero',
          (tester) async {
        final performance = _performance(
          completionRate: -0.5,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        final progress =
        tester.widget<LinearProgressIndicator>(
          find.byType(
            LinearProgressIndicator,
          ),
        );

        expect(
          progress.value,
          0.0,
        );
      },
    );

    testWidgets(
      'clamps progress above one',
          (tester) async {
        final performance = _performance(
          completionRate: 1.5,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        final progress =
        tester.widget<LinearProgressIndicator>(
          find.byType(
            LinearProgressIndicator,
          ),
        );

        expect(
          progress.value,
          1.0,
        );
      },
    );

    // ===============================================================
    // COMPLETED
    // ===============================================================

    testWidgets(
      'displays total completed',
          (tester) async {
        final performance = _performance(
          totalCompleted: 42,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('42'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // CURRENT STREAK
    // ===============================================================

    testWidgets(
      'displays current streak',
          (tester) async {
        final performance = _performance(
          currentStreak: 7,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('7'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // BEST STREAK
    // ===============================================================

    testWidgets(
      'displays best streak',
          (tester) async {
        final performance = _performance(
          bestStreak: 30,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('30'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // XP
    // ===============================================================

    testWidgets(
      'displays total XP',
          (tester) async {
        final performance = _performance(
          totalXP: 500,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('500'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ZERO VALUES
    // ===============================================================

    testWidgets(
      'renders zero values correctly',
          (tester) async {
        final performance = _performance(
          completionRate: 0,
          currentStreak: 0,
          bestStreak: 0,
          totalCompleted: 0,
          totalXP: 0,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('0%'),
          findsOneWidget,
        );

        expect(
          find.text('0'),
          findsNWidgets(4),
        );
      },
    );

    // ===============================================================
    // PERFECT COMPLETION
    // ===============================================================

    testWidgets(
      'renders 100 percent completion',
          (tester) async {
        final performance = _performance(
          completionRate: 1.0,
          totalCompleted: 100,
          currentStreak: 20,
          bestStreak: 50,
          totalXP: 1000,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('100%'),
          findsOneWidget,
        );

        expect(
          find.text('100'),
          findsOneWidget,
        );

        expect(
          find.text('20'),
          findsOneWidget,
        );

        expect(
          find.text('50'),
          findsOneWidget,
        );

        expect(
          find.text('1000'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // HIGH COMPLETION
    // ===============================================================

    testWidgets(
      'supports completion rates above 100 percent',
          (tester) async {
        final performance = _performance(
          completionRate: 1.25,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        // Display value is clamped to 100.
        expect(
          find.text('100%'),
          findsOneWidget,
        );

        final progress =
        tester.widget<LinearProgressIndicator>(
          find.byType(
            LinearProgressIndicator,
          ),
        );

        expect(
          progress.value,
          1.0,
        );
      },
    );

    // ===============================================================
    // NEGATIVE COMPLETION
    // ===============================================================

    testWidgets(
      'displays negative completion as zero percent',
          (tester) async {
        final performance = _performance(
          completionRate: -0.25,
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text('0%'),
          findsOneWidget,
        );

        final progress =
        tester.widget<LinearProgressIndicator>(
          find.byType(
            LinearProgressIndicator,
          ),
        );

        expect(
          progress.value,
          0.0,
        );
      },
    );

    // ===============================================================
    // LONG TITLE
    // ===============================================================

    testWidgets(
      'renders a long habit title without throwing',
          (tester) async {
        final performance = _performance(
          title:
          'This is a very long habit title that should be truncated',
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.text(
            'This is a very long habit title that should be truncated',
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // CONTAINER STRUCTURE
    // ===============================================================

    testWidgets(
      'renders the performance container',
          (tester) async {
        final performance = _performance();

        await tester.pumpWidget(
          _testApp(
            PerformanceTile(
              performance: performance,
            ),
          ),
        );

        expect(
          find.byType(Container),
          findsWidgets,
        );
      },
    );
  });
}

// =====================================================================
// TEST APP
// =====================================================================

Widget _testApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF2563EB),
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

// =====================================================================
// HABIT PERFORMANCE FACTORY
// =====================================================================

HabitPerformance _performance({
  String habitId = 'habit-1',
  String title = 'Test Habit',
  double completionRate = 0.5,
  int currentStreak = 5,
  int bestStreak = 10,
  int totalCompleted = 20,
  int totalXP = 200,
  int rank = 1,
}) {
  return HabitPerformance(
    habitId: habitId,
    title: title,
    completionRate: completionRate,
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    totalCompleted: totalCompleted,
    totalXP: totalXP,
    rank: rank,
  );
}