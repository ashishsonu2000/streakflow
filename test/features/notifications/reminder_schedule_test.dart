import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/entitlements/feature_access.dart';
import 'package:streak_calculator_flutter/core/entitlements/premium_config.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/notifications/domain/services/reminder_schedule.dart';
import 'package:streak_calculator_flutter/features/notifications/presentation/providers/reminder_entitlement_sync.dart';

Habit _habit({
  bool enabled = true,
  int? hour = 7,
  int? minute = 0,
  List<int> extras = const [],
  bool archived = false,
}) {
  final now = DateTime(2026, 10, 1);
  return Habit(
    id: 'habit-1',
    title: 'Water',
    reminderEnabled: enabled,
    reminderHour: hour,
    reminderMinute: minute,
    additionalReminderMinutes: extras,
    archived: archived,
    createdAt: now,
    updatedAt: now,
    startDate: now,
  );
}

void main() {
  group('Plan limits', () {
    test('free keeps the original single reminder, premium allows 5', () {
      expect(const FeatureAccess(isPremium: false).remindersPerHabit, 1);
      expect(const FeatureAccess(isPremium: true).remindersPerHabit,
          PremiumConfig.premiumRemindersPerHabit);
      expect(PremiumConfig.premiumRemindersPerHabit, 5);
    });
  });

  group('ReminderTimes.resolve', () {
    test('reminder off or missing time: nothing scheduled', () {
      expect(ReminderTimes.resolve(_habit(enabled: false), maxReminders: 5),
          isEmpty);
      expect(ReminderTimes.resolve(_habit(hour: null), maxReminders: 5),
          isEmpty);
      expect(ReminderTimes.resolve(_habit(hour: 24), maxReminders: 5),
          isEmpty);
      expect(ReminderTimes.resolve(_habit(minute: 60), maxReminders: 5),
          isEmpty);
    });

    test('existing habits (no extras) behave exactly as before', () {
      expect(ReminderTimes.resolve(_habit(), maxReminders: 1), [420]);
      expect(ReminderTimes.resolve(_habit(), maxReminders: 5), [420]);
    });

    test('free plan: extra times are kept on the habit but not scheduled',
        () {
      final habit = _habit(extras: [720, 1260]);

      expect(ReminderTimes.resolve(habit, maxReminders: 1), [420]);
      expect(habit.additionalReminderMinutes, [720, 1260]);
    });

    test('premium: primary first, extras sorted, de-duplicated, '
        'never equal to the primary, invalid values dropped', () {
      final habit = _habit(extras: [1260, 720, 720, 420, -5, 1440, 0]);

      expect(
        ReminderTimes.resolve(habit, maxReminders: 5),
        [420, 0, 720, 1260],
      );
    });

    test('capped at the plan maximum (primary included)', () {
      final habit = _habit(extras: [60, 120, 180, 240, 300, 360]);

      expect(ReminderTimes.resolve(habit, maxReminders: 5),
          [420, 60, 120, 180, 240]);
    });
  });

  group('ReminderIds', () {
    test('slot 0 keeps the IDs used before this update', () {
      expect(ReminderIds.recurring('habit-1', 0), 'habit-1'.hashCode.abs());
      final date = DateTime(2026, 10, 5);
      expect(
        ReminderIds.forDate('habit-1', date, 0),
        'habit-1-2026-10-5'.hashCode.abs(),
      );
    });

    test('extra slots are distinct, positive 31-bit and deterministic', () {
      final ids = {
        for (var slot = 0; slot < ReminderIds.maxSlots; slot++)
          ReminderIds.recurring('habit-1', slot),
      };

      expect(ids, hasLength(ReminderIds.maxSlots));
      for (final id in ids) {
        expect(id, inInclusiveRange(0, 0x7FFFFFFF));
      }

      // Stable across runs / Dart versions (FNV-1a), unlike hashCode.
      expect(
        ReminderIds.recurring('habit-1', 1),
        ReminderIds.recurring('habit-1', 1),
      );
      // Value cross-checked with an independent FNV-1a implementation.
      expect(ReminderIds.recurring('habit-1', 1), 1245266085);
    });

    test('different habits and dates get different IDs', () {
      final d1 = DateTime(2026, 10, 5);
      final d2 = DateTime(2026, 10, 6);

      expect(ReminderIds.recurring('a', 1),
          isNot(ReminderIds.recurring('b', 1)));
      expect(ReminderIds.forDate('a', d1, 1),
          isNot(ReminderIds.forDate('a', d2, 1)));
      expect(ReminderIds.forDate('a', d1, 1),
          isNot(ReminderIds.recurring('a', 1)));
    });

    test('payload identifies the habit', () {
      expect(ReminderIds.payload('habit-1'), 'habit:habit-1');
    });
  });

  test('only habits with extra times are rescheduled on a plan change', () {
    expect(needsSync(_habit()), isFalse);
    expect(needsSync(_habit(extras: [720])), isTrue);
    expect(needsSync(_habit(extras: [720], enabled: false)), isFalse);
    expect(needsSync(_habit(extras: [720], archived: true)), isFalse);
  });
}
