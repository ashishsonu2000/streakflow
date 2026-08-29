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
      'renders This Month title',
          (tester) async {
        final monthly = _monthly();

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('This Month'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders all metric labels',
          (tester) async {
        final monthly = _monthly();

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
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

    // ===============================================================
    // COMPLETION
    // ===============================================================

    testWidgets(
      'displays monthly completion percentage',
          (tester) async {
        final monthly = _monthly(
          monthlyCompletionRate: 0.75,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
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
        final monthly = _monthly(
          monthlyCompletionRate: 0.756,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('76%'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'rounds completion percentage down correctly',
          (tester) async {
        final monthly = _monthly(
          monthlyCompletionRate: 0.754,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
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
      'displays perfect days',
          (tester) async {
        final monthly = _monthly(
          perfectDays: 12,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
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
      'displays total completed habits',
          (tester) async {
        final monthly = _monthly(
          totalCompleted: 42,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
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
    // XP
    // ===============================================================

    testWidgets(
      'displays total XP',
          (tester) async {
        final monthly = _monthly(
          totalXP: 850,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('850'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // DURATION
    // ===============================================================

    testWidgets(
      'displays duration in minutes',
          (tester) async {
        final monthly = _monthly(
          totalDurationMinutes: 420,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('420 min'),
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
        final monthly = _monthly(
          monthlyCompletionRate: 0,
          totalCompleted: 0,
          totalXP: 0,
          totalDurationMinutes: 0,
          perfectDays: 0,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('0%'),
          findsOneWidget,
        );

        expect(
          find.text('0 min'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // PERFECT MONTH
    // ===============================================================

    testWidgets(
      'renders a perfect month',
          (tester) async {
        final monthly = _monthly(
          monthlyCompletionRate: 1.0,
          totalCompleted: 100,
          totalXP: 1000,
          totalDurationMinutes: 1500,
          perfectDays: 31,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
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
          find.text('1000'),
          findsOneWidget,
        );

        expect(
          find.text('1500 min'),
          findsOneWidget,
        );

        expect(
          find.text('31'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // HIGH VALUES
    // ===============================================================

    testWidgets(
      'renders large statistics values',
          (tester) async {
        final monthly = _monthly(
          monthlyCompletionRate: 0.987,
          totalCompleted: 999,
          totalXP: 99999,
          totalDurationMinutes: 12345,
          perfectDays: 31,
        );

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.text('99%'),
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
          find.text('12345 min'),
          findsOneWidget,
        );

        expect(
          find.text('31'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // WIDGET STRUCTURE
    // ===============================================================

    testWidgets(
      'renders a column containing the metrics',
          (tester) async {
        final monthly = _monthly();

        await tester.pumpWidget(
          _testApp(
            MonthlySummaryCard(
              monthly: monthly,
            ),
          ),
        );

        expect(
          find.byType(Column),
          findsWidgets,
        );

        expect(
          find.byType(Row),
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
        child: child,
      ),
    ),
  );
}

// =====================================================================
// MONTHLY STATISTICS FACTORY
// =====================================================================

MonthlyStatistics _monthly({
  double monthlyCompletionRate = 0.5,
  int totalCompleted = 10,
  int totalXP = 100,
  int totalDurationMinutes = 120,
  int perfectDays = 5,
}) {
  return MonthlyStatistics(
    monthlyCompletionRate:
    monthlyCompletionRate,
    totalCompleted: totalCompleted,
    totalXP: totalXP,
    totalDurationMinutes:
    totalDurationMinutes,
    perfectDays: perfectDays,
  );
}