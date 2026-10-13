import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';
import 'package:streak_calculator_flutter/features/settings/presentation/providers/feedback_prompt_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final start = DateTime(2026, 10, 12, 9);

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  bool shownAt(DateTime now, {bool snooze = false}) {
    final c = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        feedbackPromptClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(c.dispose);
    final shown = c.read(feedbackPromptProvider);
    if (snooze) {
      c.read(feedbackPromptProvider.notifier).snooze();
    }
    return shown;
  }

  test('hidden for the first two days of use', () {
    expect(shownAt(start), isFalse);
    expect(shownAt(start.add(const Duration(days: 1))), isFalse);
    expect(shownAt(start.add(const Duration(days: 2))), isTrue);
  });

  test('comes back a week after it was closed or feedback was sent', () {
    shownAt(start);
    final day2 = start.add(const Duration(days: 2));
    expect(shownAt(day2, snooze: true), isTrue);

    expect(shownAt(day2), isFalse);
    expect(shownAt(day2.add(const Duration(days: 6))), isFalse);
    expect(shownAt(day2.add(const Duration(days: 7))), isTrue);
  });

  test('never shown without stored preferences', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(feedbackPromptProvider), isFalse);
  });
}
