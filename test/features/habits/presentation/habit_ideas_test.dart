import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_category.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/provider/habit_form_provider.dart';
import 'package:streak_calculator_flutter/features/onboarding/domain/services/habit_suggestion_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = HabitSuggestionService();

  group('ideas for the Create Habit form', () {
    test('ideas follow the user goals', () {
      final ideas = service.ideasFor(
        goals: ['Finance'],
        existingTitles: const [],
      );

      expect(
        ideas.map((idea) => idea.title),
        ['Track Expenses', 'No Impulse Buys', 'Weekly Budget Review'],
      );
    });

    test('habits the user already has are hidden (any letter case)', () {
      final ideas = service.ideasFor(
        goals: ['Finance'],
        existingTitles: const ['track expenses '],
      );

      expect(
        ideas.map((idea) => idea.title),
        ['No Impulse Buys', 'Weekly Budget Review'],
      );
    });

    test('without goals, one idea per goal is offered', () {
      final ideas = service.ideasFor(goals: const [], existingTitles: const []);

      expect(ideas, hasLength(service.allGoals.length));
      expect(
        ideas.map((idea) => idea.category).toSet(),
        hasLength(service.allGoals.length),
      );
    });
  });

  test('applying an idea fills the form but keeps start date and reminders',
      () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(habitFormProvider.future);
    final form = container.read(habitFormProvider.notifier);

    final start = DateTime(2026, 10, 10);
    form.setStartDate(start);
    form.setReminderEnabled(true);
    form.setReminderTime(hour: 7, minute: 30);

    final idea = service
        .getSuggestions(['Fitness'])
        .firstWhere((idea) => idea.id == 'fitness-workout');
    form.applySuggestion(idea);

    final state = container.read(habitFormProvider).requireValue;
    expect(state.title, 'Workout');
    expect(state.description, '30 minutes of exercise');
    expect(state.category, HabitCategory.fitness);
    expect(state.iconCodePoint, Icons.fitness_center.codePoint);
    expect(state.colorValue, idea.colorValue);
    expect(state.frequency, HabitFrequency.weekly);
    expect(state.weeklyDays, [
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
    ]);
    expect(state.startDate, start);
    expect(state.reminderEnabled, isTrue);
    expect(state.reminderHour, 7);
    expect(state.isEditing, isFalse);
  });
}
