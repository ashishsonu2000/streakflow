import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:streak_calculator_flutter/app/app.dart';

void main() {
  testWidgets(
    'Streak Calculator app launches successfully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: StreakCalculatorApp(),
        ),
      );

      // Allow the first frame and initial async work to execute.
      // Do NOT use pumpAndSettle() here because the real app
      // may contain ongoing animations/timers/providers.
      await tester.pump(
        const Duration(milliseconds: 500),
      );

      expect(
        find.byType(StreakCalculatorApp),
        findsOneWidget,
      );
    },
  );
}