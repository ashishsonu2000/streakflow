import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/mappers/habit_form_mapper.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_form_state.dart';
import 'package:streak_calculator_flutter/features/habits/domain/services/habit_form_validator.dart';

void main() {
  const validator = HabitFormValidator();
  const mapper = HabitFormMapper();

  final start = DateTime(2026, 3, 15);

  HabitFormState validForm() => HabitFormState(
        title: 'Read',
        startDate: start,
      );

  Habit habit({
    HabitFrequency frequency = HabitFrequency.daily,
    List<int> weeklyDays = const <int>[],
    int monthlyDay = 1,
  }) {
    return Habit(
      id: 'h1',
      title: 'Read',
      description: 'Ten pages',
      frequency: frequency,
      weeklyDays: weeklyDays,
      monthlyDay: monthlyDay,
      reminderEnabled: true,
      reminderHour: 7,
      reminderMinute: 30,
      additionalReminderMinutes: const [1260],
      currentStreak: 4,
      bestStreak: 9,
      totalCompleted: 20,
      xp: 120,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      startDate: DateTime(2026, 3, 15, 18, 45),
      endDate: DateTime(2026, 12, 31, 9),
    );
  }

  group('HabitFormValidator', () {
    test('accepts a valid form', () {
      expect(validator.validate(validForm()), isNull);
    });

    test('checks the description before the title', () {
      final form = HabitFormState(
        title: '',
        description: 'x' * 501,
        startDate: start,
      );

      expect(
        validator.validate(form),
        'Description cannot exceed 500 characters.',
      );
    });

    test('rejects empty, short and long titles', () {
      expect(
        validator.validate(validForm().copyWith(title: '   ')),
        'Habit title is required.',
      );
      expect(
        validator.validate(validForm().copyWith(title: ' a ')),
        'Title is too short.',
      );
      expect(
        validator.validate(validForm().copyWith(title: 'a' * 61)),
        'Maximum 60 characters allowed.',
      );
    });

    test('rejects an end date before the start date', () {
      final form = validForm().copyWith(
        endDate: start.subtract(const Duration(days: 1)),
      );

      expect(
        validator.validate(form),
        'End date cannot be before start date.',
      );
    });

    test('requires a time when the reminder is enabled', () {
      final form = validForm().copyWith(reminderEnabled: true);

      expect(validator.validate(form), 'Please select a reminder time.');
      expect(
        validator.validate(
          form.copyWith(reminderHour: 24, reminderMinute: 0),
        ),
        'Invalid reminder hour.',
      );
      expect(
        validator.validate(
          form.copyWith(reminderHour: 8, reminderMinute: 60),
        ),
        'Invalid reminder minute.',
      );
    });
  });

  group('HabitFormMapper.forEdit', () {
    test('copies the habit and normalizes dates', () {
      final form = mapper.forEdit(HabitFormState(), habit());

      expect(form.isEditing, isTrue);
      expect(form.originalHabit?.id, 'h1');
      expect(form.title, 'Read');
      expect(form.reminderHour, 7);
      expect(form.additionalReminderMinutes, [1260]);
      expect(form.startDate, DateTime(2026, 3, 15));
      expect(form.endDate, DateTime(2026, 12, 31));
    });

    test('gives a legacy weekly habit its start weekday', () {
      final form = mapper.forEdit(
        HabitFormState(),
        habit(frequency: HabitFrequency.weekly),
      );

      expect(form.weeklyDays, [DateTime(2026, 3, 15).weekday]);
    });

    test('moves a legacy monthly day 1 to the start day', () {
      final form = mapper.forEdit(
        HabitFormState(),
        habit(frequency: HabitFrequency.monthly),
      );

      expect(form.monthlyDay, 15);
    });
  });

  group('HabitFormMapper.forDuplicate', () {
    test('creates a new habit form starting today', () {
      final today = DateTime(2026, 10, 3);
      final form = mapper.forDuplicate(habit(), today: today);

      expect(form.isEditing, isFalse);
      expect(form.originalHabit, isNull);
      expect(form.startDate, today);
      expect(form.endDate, isNull);
      expect(form.additionalReminderMinutes, [1260]);
    });
  });

  group('HabitFormMapper requests', () {
    test('create request trims the text fields', () {
      final request = mapper.toCreateRequest(
        validForm().copyWith(
          title: '  Read  ',
          description: ' Ten pages ',
        ),
      );

      expect(request.title, 'Read');
      expect(request.description, 'Ten pages');
      expect(request.startDate, start);
    });

    test('update request keeps the habit progress', () {
      final form = mapper.forEdit(HabitFormState(), habit())
          .copyWith(title: 'Read more');

      final request = mapper.toUpdateRequest(form);

      expect(request.id, 'h1');
      expect(request.title, 'Read more');
      expect(request.currentStreak, 4);
      expect(request.bestStreak, 9);
      expect(request.totalCompleted, 20);
      expect(request.xp, 120);
    });
  });
}
