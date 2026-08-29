import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/statistics/domain/models/habit_performance.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/performance/performance_section.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/performance/performance_tile.dart';

void main() {
  group('PerformanceSection', () {
    // ===============================================================
    // BASIC RENDERING
    // ===============================================================

    testWidgets(
      'renders Habit Performance title',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(),
              ],
            ),
          ),
        );

        expect(
          find.text('Habit Performance'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // EMPTY STATE
    // ===============================================================

    testWidgets(
      'renders empty state when performance is empty',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const PerformanceSection(
              performance: [],
            ),
          ),
        );

        expect(
          find.text('Habit Performance'),
          findsOneWidget,
        );

        expect(
          find.text('No performance data yet'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Complete some habits to see your performance.',
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.insights_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // SINGLE PERFORMANCE
    // ===============================================================

    testWidgets(
      'renders one PerformanceTile for one performance item',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(
                  title: 'Exercise',
                ),
              ],
            ),
          ),
        );

        expect(
          find.byType(PerformanceTile),
          findsOneWidget,
        );

        expect(
          find.text('Exercise'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // MULTIPLE PERFORMANCE ITEMS
    // ===============================================================

    testWidgets(
      'renders multiple PerformanceTiles',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(
                  habitId: 'habit-1',
                  title: 'Exercise',
                ),
                _performance(
                  habitId: 'habit-2',
                  title: 'Reading',
                ),
                _performance(
                  habitId: 'habit-3',
                  title: 'Meditation',
                ),
              ],
            ),
          ),
        );

        expect(
          find.byType(PerformanceTile),
          findsNWidgets(3),
        );

        expect(
          find.text('Exercise'),
          findsOneWidget,
        );

        expect(
          find.text('Reading'),
          findsOneWidget,
        );

        expect(
          find.text('Meditation'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ORDER
    // ===============================================================

    testWidgets(
      'preserves performance item order',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(
                  habitId: 'first',
                  title: 'First Habit',
                ),
                _performance(
                  habitId: 'second',
                  title: 'Second Habit',
                ),
                _performance(
                  habitId: 'third',
                  title: 'Third Habit',
                ),
              ],
            ),
          ),
        );

        final first =
        tester.getTopLeft(
          find.text('First Habit'),
        );

        final second =
        tester.getTopLeft(
          find.text('Second Habit'),
        );

        final third =
        tester.getTopLeft(
          find.text('Third Habit'),
        );

        expect(
          first.dy,
          lessThan(second.dy),
        );

        expect(
          second.dy,
          lessThan(third.dy),
        );
      },
    );

    // ===============================================================
    // PERFORMANCE DATA
    // ===============================================================

    testWidgets(
      'passes performance data to each tile',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(
                  title: 'Exercise',
                  completionRate: 0.80,
                  currentStreak: 8,
                  bestStreak: 15,
                  totalCompleted: 40,
                  totalXP: 400,
                ),
              ],
            ),
          ),
        );

        expect(
          find.text('Exercise'),
          findsOneWidget,
        );

        expect(
          find.text('80%'),
          findsOneWidget,
        );

        expect(
          find.text('8'),
          findsOneWidget,
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );

        expect(
          find.text('40'),
          findsOneWidget,
        );

        expect(
          find.text('400'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // TWO ITEMS
    // ===============================================================

    testWidgets(
      'renders exactly two tiles for two performance items',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(
                  title: 'Exercise',
                ),
                _performance(
                  title: 'Reading',
                ),
              ],
            ),
          ),
        );

        expect(
          find.byType(PerformanceTile),
          findsNWidgets(2),
        );
      },
    );

    // ===============================================================
    // FIVE ITEMS
    // ===============================================================

    testWidgets(
      'renders all five performance items',
          (tester) async {
        final performance = List.generate(
          5,
              (index) {
            return _performance(
              habitId: 'habit-$index',
              title: 'Habit $index',
            );
          },
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: performance,
            ),
          ),
        );

        expect(
          find.byType(PerformanceTile),
          findsNWidgets(5),
        );
      },
    );

    // ===============================================================
    // LARGE LIST
    // ===============================================================

    testWidgets(
      'renders a larger performance list',
          (tester) async {
        final performance = List.generate(
          10,
              (index) {
            return _performance(
              habitId: 'habit-$index',
              title: 'Habit $index',
            );
          },
        );

        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: performance,
            ),
          ),
        );

        expect(
          find.byType(PerformanceTile),
          findsNWidgets(10),
        );
      },
    );

    // ===============================================================
    // EMPTY STATE DOES NOT RENDER PERFORMANCE TILE
    // ===============================================================

    testWidgets(
      'does not render PerformanceTile for empty data',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const PerformanceSection(
              performance: [],
            ),
          ),
        );

        expect(
          find.byType(PerformanceTile),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // EMPTY STATE ICON
    // ===============================================================

    testWidgets(
      'renders insights icon in empty state',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const PerformanceSection(
              performance: [],
            ),
          ),
        );

        expect(
          find.byIcon(
            Icons.insights_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // DIFFERENT COMPLETION STATES
    // ===============================================================

    testWidgets(
      'renders tiles with different completion rates',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            PerformanceSection(
              performance: [
                _performance(
                  title: 'Low',
                  completionRate: 0.25,
                ),
                _performance(
                  title: 'Medium',
                  completionRate: 0.50,
                ),
                _performance(
                  title: 'Complete',
                  completionRate: 1.0,
                ),
              ],
            ),
          ),
        );

        expect(
          find.text('25%'),
          findsOneWidget,
        );

        expect(
          find.text('50%'),
          findsOneWidget,
        );

        expect(
          find.text('100%'),
          findsOneWidget,
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
        padding: const EdgeInsets.all(16),
        child: child,
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