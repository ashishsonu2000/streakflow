import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/achievements/domain/enums/achievement_type.dart';
import 'package:streak_calculator_flutter/features/achievements/domain/models/achievement.dart';
import 'package:streak_calculator_flutter/features/achievements/presentation/widgets/achievement_card.dart';

Achievement _streak3({required int current}) {
  return Achievement(
    type: AchievementType.streak3,
    title: 'Getting Started',
    description: 'Maintain a 3-day streak.',
    icon: Icons.local_fire_department,
    unlocked: current >= 3,
    progress: (current / 3).clamp(0.0, 1.0),
    category: 'Streak',
    currentValue: current,
    targetValue: 3,
  );
}

Future<void> _pump(WidgetTester tester, Achievement achievement) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: AchievementCard(achievement: achievement),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('an unlocked achievement says so instead of "29/3"',
      (tester) async {
    await _pump(tester, _streak3(current: 29));

    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('29/3'), findsNothing);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('a locked achievement shows its progress', (tester) async {
    await _pump(tester, _streak3(current: 1));

    expect(find.text('1/3'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
  });
}
