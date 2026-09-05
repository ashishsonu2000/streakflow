import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/statistics/domain/models/monthly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/monthly/monthly_summary_card.dart';

void main() {
  group('MonthlySummaryCard', () {
    // ===============================================================
    // BASIC RENDERING
    // ===============================================================

    testWidgets(
      'renders monthly summary card',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: _defaultMonthlyStatistics,
            ),
          ),
        );

        expect(
          find.byType(MonthlySummaryCard),
          findsOneWidget,
        );

        expect(
          find.text('This Month'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETION
    // ===============================================================

    testWidgets(
      'renders completion percentage',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.75,
                totalCompleted: 75,
                totalXP: 750,
                totalDurationMinutes: 1125,
                perfectDays: 12,
              ),
            ),
          ),
        );

        expect(
          find.text('Completion'),
          findsOneWidget,
        );

        expect(
          find.text('75%'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // PERFECT DAYS
    // ===============================================================

    testWidgets(
      'renders perfect days',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.75,
                totalCompleted: 75,
                totalXP: 750,
                totalDurationMinutes: 1125,
                perfectDays: 12,
              ),
            ),
          ),
        );

        expect(
          find.text('Perfect Days'),
          findsOneWidget,
        );

        expect(
          find.text('12'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETED
    // ===============================================================

    testWidgets(
      'renders total completed habits',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.80,
                totalCompleted: 42,
                totalXP: 500,
                totalDurationMinutes: 600,
                perfectDays: 8,
              ),
            ),
          ),
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('42'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // XP
    // ===============================================================

    testWidgets(
      'renders total XP',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.90,
                totalCompleted: 90,
                totalXP: 1234,
                totalDurationMinutes: 900,
                perfectDays: 20,
              ),
            ),
          ),
        );

        expect(
          find.text('XP'),
          findsOneWidget,
        );

        expect(
          find.text('1234'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // DURATION
    // ===============================================================

    testWidgets(
      'renders duration in minutes',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.65,
                totalCompleted: 30,
                totalXP: 300,
                totalDurationMinutes: 135,
                perfectDays: 5,
              ),
            ),
          ),
        );

        expect(
          find.text('Duration'),
          findsOneWidget,
        );

        expect(
          find.text('135 min'),
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
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.0,
                totalCompleted: 0,
                totalXP: 0,
                totalDurationMinutes: 0,
                perfectDays: 0,
              ),
            ),
          ),
        );

        expect(
          find.text('Completion'),
          findsOneWidget,
        );

        expect(
          find.text('0%'),
          findsOneWidget,
        );

        expect(
          find.text('Perfect Days'),
          findsOneWidget,
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('XP'),
          findsOneWidget,
        );

        expect(
          find.text('Duration'),
          findsOneWidget,
        );

        expect(
          find.text('0 min'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ROUNDING
    // ===============================================================

    testWidgets(
      'rounds completion percentage to nearest whole number',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 0.756,
                totalCompleted: 75,
                totalXP: 750,
                totalDurationMinutes: 100,
                perfectDays: 10,
              ),
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
    // HIGH VALUES
    // ===============================================================

    testWidgets(
      'renders large metric values',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: MonthlyStatistics(
                monthlyCompletionRate: 1.0,
                totalCompleted: 999,
                totalXP: 99999,
                totalDurationMinutes: 9999,
                perfectDays: 31,
              ),
            ),
          ),
        );

        expect(
          find.text('100%'),
          findsOneWidget,
        );

        expect(
          find.text('999'),
          findsOneWidget,
        );

        expect(
          find.text('99999'),
          findsOneWidget,
        );

        expect(
          find.text('9999 min'),
          findsOneWidget,
        );

        expect(
          find.text('31'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // NEW MONTHLY METRICS
    // ===============================================================
    //
    // MonthlyStatistics supports totalScheduled, totalMissed,
    // previousMonthCompletionRate and monthlyChangePercentage.
    //
    // MonthlySummaryCard currently does NOT render these values.
    // Therefore these tests intentionally verify that the model
    // accepts them without expecting them to appear in the card.
    //

    testWidgets(
      'renders correctly when new monthly metrics are provided',
          (tester) async {
        const monthly = MonthlyStatistics(
          monthlyCompletionRate: 0.82,
          totalCompleted: 82,
          totalXP: 820,
          totalDurationMinutes: 1200,
          perfectDays: 15,
          totalScheduled: 100,
          totalMissed: 18,
          previousMonthCompletionRate: 0.74,
          monthlyChangePercentage: 8,
        );

        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('82%'),
          findsOneWidget,
        );

        expect(
          find.text('82'),
          findsOneWidget,
        );

        expect(
          find.text('820'),
          findsOneWidget,
        );

        expect(
          find.text('1200 min'),
          findsOneWidget,
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // NEGATIVE / DECLINING CHANGE
    // ===============================================================

    testWidgets(
      'renders correctly when monthly performance is declining',
          (tester) async {
        const monthly = MonthlyStatistics(
          monthlyCompletionRate: 0.60,
          totalCompleted: 60,
          totalXP: 600,
          totalDurationMinutes: 900,
          perfectDays: 5,
          totalScheduled: 100,
          totalMissed: 40,
          previousMonthCompletionRate: 0.80,
          monthlyChangePercentage: -20,
        );

        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('60%'),
          findsOneWidget,
        );

        expect(
          find.text('60'),
          findsOneWidget,
        );

        expect(
          find.text('600'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // WIDGET STRUCTURE
    // ===============================================================

    testWidgets(
      'renders all expected metric labels',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const MonthlySummaryCard(
              monthly: _defaultMonthlyStatistics,
            ),
          ),
        );

        expect(
          find.text('Completion'),
          findsOneWidget,
        );

        expect(
          find.text('Perfect Days'),
          findsOneWidget,
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('XP'),
          findsOneWidget,
        );

        expect(
          find.text('Duration'),
          findsOneWidget,
        );
      },
    );
  });
}

// =====================================================================
// DEFAULT TEST DATA
// =====================================================================

const _defaultMonthlyStatistics = MonthlyStatistics(
  monthlyCompletionRate: 0.75,
  totalCompleted: 75,
  totalXP: 750,
  totalDurationMinutes: 1125,
  perfectDays: 12,
);

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
      body: child,
    ),
  );
}