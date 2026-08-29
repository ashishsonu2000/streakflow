import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/dashboard/widgets/insights/insight_card.dart';


void main() {
  group('InsightCard', () {
    testWidgets(
      'renders title and message',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.insights_rounded,
              color: Color(0xFF2563EB),
              title: 'Great Progress',
              message:
              'You completed most of your habits this week.',
            ),
          ),
        );

        expect(
          find.text('Great Progress'),
          findsOneWidget,
        );

        expect(
          find.text(
            'You completed most of your habits this week.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders supplied icon',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.trending_up_rounded,
              color: Color(0xFF16A34A),
              title: 'Improving',
              message: 'Your consistency is improving.',
            ),
          ),
        );

        expect(
          find.byIcon(
            Icons.trending_up_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders custom icon color',
          (tester) async {
        const color = Color(0xFF16A34A);

        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.check_circle_rounded,
              color: color,
              title: 'Excellent',
              message: 'Keep going.',
            ),
          ),
        );

        final icon = tester.widget<Icon>(
          find.byIcon(
            Icons.check_circle_rounded,
          ),
        );

        expect(
          icon.color,
          color,
        );
      },
    );

    testWidgets(
      'renders long message without throwing',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.info_outline_rounded,
              color: Color(0xFF2563EB),
              title: 'Consistency Insight',
              message:
              'You have been consistently completing your habits '
                  'throughout the week. Keep maintaining this positive '
                  'routine and continue building your streak.',
            ),
          ),
        );

        expect(
          find.text('Consistency Insight'),
          findsOneWidget,
        );

        expect(
          find.textContaining(
            'You have been consistently completing',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders long title',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.lightbulb_outline_rounded,
              color: Color(0xFF7C3AED),
              title:
              'This is a very long insight title that should '
                  'be limited to two lines',
              message: 'Keep improving.',
            ),
          ),
        );

        expect(
          find.textContaining(
            'This is a very long insight title',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders empty message',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.info_outline_rounded,
              color: Color(0xFF2563EB),
              title: 'Information',
              message: '',
            ),
          ),
        );

        expect(
          find.text('Information'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders empty title',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.info_outline_rounded,
              color: Color(0xFF2563EB),
              title: '',
              message: 'Some useful information.',
            ),
          ),
        );

        expect(
          find.text('Some useful information.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders multiple different icons correctly',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const Column(
              children: [
                InsightCard(
                  icon: Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  title: 'Success',
                  message: 'Completed.',
                ),
                InsightCard(
                  icon: Icons.warning_amber_rounded,
                  color: Color(0xFFD97706),
                  title: 'Attention',
                  message: 'Needs attention.',
                ),
              ],
            ),
          ),
        );

        expect(
          find.byIcon(
            Icons.check_circle_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.warning_amber_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.text('Success'),
          findsOneWidget,
        );

        expect(
          find.text('Attention'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders the card container',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.insights_rounded,
              color: Color(0xFF2563EB),
              title: 'Insight',
              message: 'Message',
            ),
          ),
        );

        expect(
          find.byType(Container),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'renders content inside a row',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.insights_rounded,
              color: Color(0xFF2563EB),
              title: 'Insight',
              message: 'Message',
            ),
          ),
        );

        expect(
          find.byType(Row),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'renders title with maximum two lines',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const InsightCard(
              icon: Icons.insights_rounded,
              color: Color(0xFF2563EB),
              title:
              'A long title that should never occupy more than two lines',
              message: 'Message',
            ),
          ),
        );

        final titleFinder = find.text(
          'A long title that should never occupy more than two lines',
        );

        expect(
          titleFinder,
          findsOneWidget,
        );

        final title = tester.widget<Text>(
          titleFinder,
        );

        expect(
          title.maxLines,
          2,
        );

        expect(
          title.overflow,
          TextOverflow.ellipsis,
        );
      },
    );

    testWidgets(
      'expands to the available width',
          (tester) async {
        const screenWidth = 400.0;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: const Scaffold(
              body: SizedBox(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: InsightCard(
                    icon: Icons.insights_rounded,
                    color: Color(0xFF2563EB),
                    title: 'Insight',
                    message: 'Message',
                  ),
                ),
              ),
            ),
          ),
        );

        final card = find.byType(InsightCard);

        expect(
          card,
          findsOneWidget,
        );

        final size = tester.getSize(card);

        expect(
          size.width,
          screenWidth - 32,
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