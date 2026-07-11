import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/app/app.dart';
import 'package:streak_calculator_flutter/main.dart';

void main() {
  testWidgets('shows the streak calculator dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const StreakCalculatorApp());
    await tester.pumpAndSettle();

    expect(find.text('DAILY STREAK DASHBOARD'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);

    expect(find.text('Total tasks'), findsOneWidget);
  });
}
