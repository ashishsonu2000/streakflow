import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/provider/habit_form_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late HabitFormNotifier form;

  List<int> extras() =>
      container.read(habitFormProvider).requireValue.additionalReminderMinutes;

  setUp(() async {
    container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(habitFormProvider.future);
    form = container.read(habitFormProvider.notifier);

    form.setReminderEnabled(true);
    form.setReminderTime(hour: 7, minute: 0);
  });

  test('a new habit form has no extra reminders', () {
    expect(extras(), isEmpty);
  });

  test('adds extra times in sorted order', () {
    expect(form.addAdditionalReminder(21 * 60), isTrue);
    expect(form.addAdditionalReminder(12 * 60), isTrue);

    expect(extras(), [720, 1260]);
  });

  test('rejects duplicates, the primary time and invalid values', () {
    form.addAdditionalReminder(720);

    expect(form.addAdditionalReminder(720), isFalse, reason: 'duplicate');
    expect(form.addAdditionalReminder(7 * 60), isFalse, reason: 'primary');
    expect(form.addAdditionalReminder(-1), isFalse);
    expect(form.addAdditionalReminder(24 * 60), isFalse);
    expect(extras(), [720]);
  });

  test('stops at the Premium maximum per habit (primary included)', () {
    final maxExtra = PremiumConfig.premiumRemindersPerHabit - 1;

    for (var i = 0; i < maxExtra + 2; i++) {
      form.addAdditionalReminder(600 + i * 60);
    }

    expect(extras(), hasLength(maxExtra));
  });

  test('removes a reminder time', () {
    form.addAdditionalReminder(720);
    form.addAdditionalReminder(1260);

    form.removeAdditionalReminder(720);

    expect(extras(), [1260]);
  });
}
