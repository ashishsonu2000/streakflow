import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/entitlements/feature_access.dart';
import 'package:streak_calculator_flutter/core/ui/icons/habit_icon_resolver.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/habit_frequency.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_category.dart';
import 'package:streak_calculator_flutter/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_calculator_flutter/features/habits/domain/services/habit_limit_guard.dart';
import 'package:streak_calculator_flutter/features/onboarding/domain/services/habit_suggestion_service.dart';
import 'package:streak_calculator_flutter/features/onboarding/domain/usecases/create_suggested_habit_usecase.dart';
import 'package:streak_calculator_flutter/features/onboarding/presentation/pages/goal_selection_page.dart';
import 'package:streak_calculator_flutter/features/onboarding/presentation/pages/habit_suggestions_page.dart';
import 'package:streak_calculator_flutter/features/onboarding/presentation/providers/onboarding_provider.dart';

/// Stores saved habits; everything else is unused here.
class _Repo implements HabitRepository {
  _Repo([List<Habit>? habits]) : habits = habits ?? [];

  final List<Habit> habits;

  @override
  Future<void> save(Habit habit) async => habits.add(habit);

  @override
  Future<List<Habit>> getAllForCalendar() async =>
      habits.where((habit) => !habit.archived).toList();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Habit _existing(String title) => Habit(
      id: title,
      title: title,
      createdAt: DateTime(2026, 9, 1),
      updatedAt: DateTime(2026, 9, 1),
      startDate: DateTime(2026, 9, 1),
    );

void main() {
  const service = HabitSuggestionService();
  const goals = GoalSelectionPage.goals;

  group('HabitSuggestionService', () {
    test('every goal on the goal page has three suggestions', () {
      for (final goal in goals) {
        expect(service.getSuggestions([goal]), hasLength(3), reason: goal);
      }
    });

    test('suggestion ids are unique', () {
      final ids = service.getSuggestions(goals).map((h) => h.id).toList();

      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every suggested icon can be displayed (not the fallback tick)', () {
      for (final habit in service.getSuggestions(goals)) {
        expect(
          habitIconFromCodePoint(habit.icon.codePoint),
          habit.icon,
          reason: habit.title,
        );
      }
    });

    test('weekly suggestions have valid weekdays', () {
      for (final habit in service.getSuggestions(goals)) {
        if (habit.frequency == HabitFrequency.weekly) {
          expect(habit.weeklyDays, isNotEmpty, reason: habit.title);
          expect(
            habit.weeklyDays.every((day) => day >= 1 && day <= 7),
            isTrue,
          );
        }
      }
    });

    test('the first suggestion of each picked goal is selected by default',
        () {
      expect(
        service.defaultSelection(['Health', 'Finance']),
        {'health-water', 'finance-expenses'},
      );
      expect(service.defaultSelection(const []), isEmpty);
    });

    test('all suggestions together stay within the Free plan limit', () {
      expect(
        service.getSuggestions(goals).length,
        lessThanOrEqualTo(const FeatureAccess(isPremium: false).freeHabitLimit),
      );
    });
  });

  group('CreateSuggestedHabitUseCase.executeAll', () {
    final now = DateTime(2026, 10, 4, 9, 30);

    test('creates the habits with their icon, colour, category and schedule',
        () async {
      final repo = _Repo();
      final picked = service
          .getSuggestions(['Finance'])
          .where((h) => h.id == 'finance-budget-review')
          .toList();

      final created = await CreateSuggestedHabitUseCase(repo, now: () => now)
          .executeAll(picked);

      expect(created, 1);
      final habit = repo.habits.single;
      expect(habit.title, 'Weekly Budget Review');
      expect(habit.category, HabitCategory.finance);
      expect(habit.iconCodePoint, Icons.attach_money.codePoint);
      expect(habit.frequency, HabitFrequency.weekly);
      expect(habit.weeklyDays, [DateTime.sunday]);
      expect(habit.startDate, DateTime(2026, 10, 4));
      expect(habit.reminderEnabled, isFalse);
    });

    test('skips suggestions that match an existing habit', () async {
      final repo = _Repo([_existing('drink water')]);

      final created = await CreateSuggestedHabitUseCase(repo, now: () => now)
          .executeAll(service.getSuggestions(['Health']));

      expect(created, 2);
      expect(
        repo.habits.map((h) => h.title),
        ['drink water', 'Morning Walk', 'Sleep by 11 PM'],
      );
    });

    test('stops quietly at the Free plan limit', () async {
      final repo = _Repo([for (var i = 0; i < 4; i++) _existing('h$i')]);
      final guard = HabitLimitGuard(
        countActiveHabits: () async => repo.habits.length,
        access: () =>
            const FeatureAccess(isPremium: false, freeHabitLimit: 5),
      );

      final created =
          await CreateSuggestedHabitUseCase(repo, limitGuard: guard)
              .executeAll(service.getSuggestions(['Health']));

      expect(created, 1);
      expect(repo.habits, hasLength(5));
    });
  });

  group('onboarding selection', () {
    test('choosing goals pre-selects; toggling adds and removes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(onboardingProvider.notifier);

      notifier.toggleGoal('Health');
      notifier.toggleGoal('Learning');
      expect(
        container.read(onboardingProvider).selectedSuggestionIds,
        {'health-water', 'learning-read'},
      );

      notifier.toggleSuggestion('health-water');
      notifier.toggleSuggestion('health-sleep');
      expect(
        container.read(onboardingProvider).selectedSuggestionIds,
        {'learning-read', 'health-sleep'},
      );

      notifier.toggleGoal('Learning');
      expect(
        container.read(onboardingProvider).selectedSuggestionIds,
        {'health-water'},
      );
    });

    testWidgets('the page lists suggestions and toggles them on tap',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(onboardingProvider.notifier).toggleGoal('Mindfulness');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: HabitSuggestionsPage())),
        ),
      );

      expect(find.text('Meditate'), findsOneWidget);
      expect(find.text('Gratitude Journal'), findsOneWidget);
      expect(find.text('1 habit selected'), findsOneWidget);

      await tester.tap(find.text('Gratitude Journal'));
      await tester.pump();

      expect(find.text('2 habits selected'), findsOneWidget);
      expect(
        container.read(onboardingProvider).selectedSuggestionIds,
        {'mindfulness-meditate', 'mindfulness-gratitude'},
      );
    });
  });
}
