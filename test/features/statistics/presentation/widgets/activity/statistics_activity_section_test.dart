import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/activity/statistics_activity_section.dart';

void main() {
  group('StatisticsActivitySection', () {
    // ===============================================================
    // EMPTY STATE
    // ===============================================================

    testWidgets(
      'renders empty state when there are no logs',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsActivitySection(
              logs: [],
            ),
          ),
        );

        expect(
          find.text('Recent Activity'),
          findsOneWidget,
        );

        expect(
          find.text('No activity yet'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Complete a habit to see it here.',
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.history_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETED ACTIVITY
    // ===============================================================

    testWidgets(
      'renders completed activity',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 8, 20),
          completedAt: DateTime(2026, 8, 20, 9, 30),
          xpEarned: 25,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.text('20 Aug 2026'),
          findsOneWidget,
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('+25 XP'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.check_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // MISSED ACTIVITY
    // ===============================================================

    testWidgets(
      'renders missed activity',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 8, 19),
          completedAt: null,
          xpEarned: 0,
          status: CompletionStatus.missed,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.text('19 Aug 2026'),
          findsOneWidget,
        );

        expect(
          find.text('Missed'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.remove_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // XP BADGE
    // ===============================================================

    testWidgets(
      'shows XP badge when XP is greater than zero',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 8, 18),
          completedAt: DateTime(2026, 8, 18, 10),
          xpEarned: 50,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.text('+50 XP'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'hides XP badge when XP is zero',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 8, 18),
          completedAt: DateTime(2026, 8, 18, 10),
          xpEarned: 0,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.textContaining('XP'),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // DATE FORMATTING
    // ===============================================================

    testWidgets(
      'formats activity date as dd MMM yyyy',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 1, 5),
          completedAt: DateTime(2026, 1, 5, 8),
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.text('05 Jan 2026'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // NEWEST FIRST
    // ===============================================================

    testWidgets(
      'displays newest logs first',
          (tester) async {
        final older = _log(
          id: 'older',
          date: DateTime(2026, 8, 10),
          completedAt: DateTime(2026, 8, 10, 9),
          xpEarned: 10,
        );

        final newer = _log(
          id: 'newer',
          date: DateTime(2026, 8, 20),
          completedAt: DateTime(2026, 8, 20, 9),
          xpEarned: 20,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [older, newer],
            ),
          ),
        );

        final olderFinder =
        find.text('10 Aug 2026');
        final newerFinder =
        find.text('20 Aug 2026');

        expect(
          newerFinder,
          findsOneWidget,
        );

        expect(
          olderFinder,
          findsOneWidget,
        );

        final newerY =
            tester.getTopLeft(newerFinder).dy;
        final olderY =
            tester.getTopLeft(olderFinder).dy;

        expect(
          newerY,
          lessThan(olderY),
        );
      },
    );

    // ===============================================================
    // MAXIMUM FIVE ITEMS
    // ===============================================================

    testWidgets(
      'displays at most five recent logs',
          (tester) async {
        final logs = List.generate(
          7,
              (index) {
            final day = 10 + index;

            return _log(
              id: 'log-$index',
              date: DateTime(
                2026,
                8,
                day,
              ),
              completedAt: DateTime(
                2026,
                8,
                day,
                9,
              ),
              xpEarned: index + 1,
            );
          },
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: logs,
            ),
          ),
        );

        expect(
          find.byIcon(
            Icons.check_rounded,
          ),
          findsNWidgets(5),
        );

        expect(
          find.text('+7 XP'),
          findsOneWidget,
        );

        expect(
          find.text('+6 XP'),
          findsOneWidget,
        );

        expect(
          find.text('+5 XP'),
          findsOneWidget,
        );

        expect(
          find.text('+4 XP'),
          findsOneWidget,
        );

        expect(
          find.text('+3 XP'),
          findsOneWidget,
        );

        expect(
          find.text('+2 XP'),
          findsNothing,
        );

        expect(
          find.text('+1 XP'),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // EXACT FIVE ITEMS
    // ===============================================================

    testWidgets(
      'renders all five logs when exactly five are provided',
          (tester) async {
        final logs = List.generate(
          5,
              (index) {
            final day = 10 + index;

            return _log(
              id: 'log-$index',
              date: DateTime(
                2026,
                8,
                day,
              ),
              completedAt: DateTime(
                2026,
                8,
                day,
                9,
              ),
              xpEarned: 10 + index,
            );
          },
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: logs,
            ),
          ),
        );

        expect(
          find.byIcon(
            Icons.check_rounded,
          ),
          findsNWidgets(5),
        );
      },
    );

    // ===============================================================
    // COMPLETED / MISSED MIX
    // ===============================================================

    testWidgets(
      'renders completed and missed logs together',
          (tester) async {
        final completed = _log(
          id: 'completed',
          date: DateTime(2026, 8, 20),
          completedAt: DateTime(
            2026,
            8,
            20,
            10,
          ),
          xpEarned: 20,
          status: CompletionStatus.completed,
        );

        final missed = _log(
          id: 'missed',
          date: DateTime(2026, 8, 19),
          completedAt: null,
          xpEarned: 0,
          status: CompletionStatus.missed,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [
                missed,
                completed,
              ],
            ),
          ),
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('Missed'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.check_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.remove_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // NEGATIVE XP
    // ===============================================================

    testWidgets(
      'hides XP badge for negative XP',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 8, 20),
          completedAt: DateTime(
            2026,
            8,
            20,
            10,
          ),
          xpEarned: -10,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.textContaining('XP'),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // SINGLE ITEM
    // ===============================================================

    testWidgets(
      'renders a single activity item without errors',
          (tester) async {
        final log = _log(
          date: DateTime(2026, 8, 25),
          completedAt: DateTime(
            2026,
            8,
            25,
            12,
          ),
          xpEarned: 15,
        );

        await tester.pumpWidget(
          _testApp(
            StatisticsActivitySection(
              logs: [log],
            ),
          ),
        );

        expect(
          find.text('25 Aug 2026'),
          findsOneWidget,
        );

        expect(
          find.text('+15 XP'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // SECTION TITLE
    // ===============================================================

    testWidgets(
      'always displays Recent Activity title',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsActivitySection(
              logs: [],
            ),
          ),
        );

        expect(
          find.text('Recent Activity'),
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
// HABIT LOG FACTORY
// =====================================================================

HabitLog _log({
  String id = 'log-1',
  String habitId = 'habit-1',
  DateTime? date,
  CompletionStatus status =
      CompletionStatus.completed,
  DateTime? completedAt,
  int durationMinutes = 15,
  String notes = '',
  int xpEarned = 10,
}) {
  final logDate =
      date ?? DateTime(2026, 8, 20);

  return HabitLog(
    id: id,
    habitId: habitId,
    date: logDate,
    status: status,
    completedAt: completedAt,
    durationMinutes: durationMinutes,
    notes: notes,
    xpEarned: xpEarned,
  );
}