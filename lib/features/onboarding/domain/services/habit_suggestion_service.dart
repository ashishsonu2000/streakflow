import 'package:flutter/material.dart';

import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/models/habit_category.dart';
import '../models/suggested_habit.dart';

/// Ready-made habits for the goals picked during onboarding.
///
/// Each goal has three suggestions; the first one is pre-selected.
/// Goals are the labels shown on the goal selection page.
class HabitSuggestionService {
  const HabitSuggestionService();

  /// Suggestions for [goals], in the order the goals were picked.
  List<SuggestedHabit> getSuggestions(List<String> goals) {
    return [
      for (final goal in goals) ...?_byGoal[goal],
    ];
  }

  /// Every goal that has suggestions, in display order.
  List<String> get allGoals => _byGoal.keys.toList();

  /// Ideas for the Create Habit form: the suggestions for [goals] (the
  /// first one of every goal when the user picked none), without habits
  /// the user already has ([existingTitles], compared case-insensitively).
  List<SuggestedHabit> ideasFor({
    required List<String> goals,
    required Iterable<String> existingTitles,
  }) {
    final candidates = goals.isEmpty
        ? [for (final list in _byGoal.values) list.first]
        : getSuggestions(goals);

    return withoutExisting(candidates, existingTitles);
  }

  /// [suggestions] minus the ones whose title the user already has.
  List<SuggestedHabit> withoutExisting(
    List<SuggestedHabit> suggestions,
    Iterable<String> existingTitles,
  ) {
    final taken = {
      for (final title in existingTitles) title.trim().toLowerCase(),
    };

    return [
      for (final habit in suggestions)
        if (!taken.contains(habit.title.trim().toLowerCase())) habit,
    ];
  }

  /// The suggestions selected by default: the first one of each goal.
  Set<String> defaultSelection(List<String> goals) {
    return {
      for (final goal in goals)
        if (_byGoal[goal] case final list? when list.isNotEmpty) list.first.id,
    };
  }

  static const Map<String, List<SuggestedHabit>> _byGoal = {
    'Health': [
      SuggestedHabit(
        id: 'health-water',
        title: 'Drink Water',
        description: '8 glasses through the day',
        category: HabitCategory.health,
        icon: Icons.water_drop,
        colorValue: 0xFF2196F3,
        durationMinutes: 5,
      ),
      SuggestedHabit(
        id: 'health-walk',
        title: 'Morning Walk',
        description: '20 minutes outside',
        category: HabitCategory.health,
        icon: Icons.directions_run,
        colorValue: 0xFF4CAF50,
        durationMinutes: 20,
      ),
      SuggestedHabit(
        id: 'health-sleep',
        title: 'Sleep by 11 PM',
        description: 'Screens off and lights out',
        category: HabitCategory.health,
        icon: Icons.bedtime,
        colorValue: 0xFF3F51B5,
        durationMinutes: 5,
      ),
    ],
    'Fitness': [
      SuggestedHabit(
        id: 'fitness-workout',
        title: 'Workout',
        description: '30 minutes of exercise',
        category: HabitCategory.fitness,
        icon: Icons.fitness_center,
        colorValue: 0xFFF44336,
        frequency: HabitFrequency.weekly,
        weeklyDays: [
          DateTime.monday,
          DateTime.wednesday,
          DateTime.friday,
        ],
        durationMinutes: 30,
      ),
      SuggestedHabit(
        id: 'fitness-stretch',
        title: 'Stretching',
        description: '10 minutes',
        category: HabitCategory.fitness,
        icon: Icons.sports_gymnastics,
        colorValue: 0xFFFF9800,
        durationMinutes: 10,
      ),
      SuggestedHabit(
        id: 'fitness-steps',
        title: '10,000 Steps',
        description: 'Keep moving through the day',
        category: HabitCategory.fitness,
        icon: Icons.hiking,
        colorValue: 0xFF009688,
        durationMinutes: 60,
      ),
    ],
    'Productivity': [
      SuggestedHabit(
        id: 'productivity-plan',
        title: 'Plan the Day',
        description: 'Write your top 3 tasks',
        category: HabitCategory.productivity,
        icon: Icons.task_alt,
        colorValue: 0xFF673AB7,
        durationMinutes: 5,
      ),
      SuggestedHabit(
        id: 'productivity-deep-work',
        title: 'Deep Work',
        description: '60 minutes of focused work',
        category: HabitCategory.productivity,
        icon: Icons.laptop_mac,
        colorValue: 0xFF3F51B5,
        frequency: HabitFrequency.weekly,
        weeklyDays: [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
        ],
        durationMinutes: 60,
      ),
      SuggestedHabit(
        id: 'productivity-no-phone',
        title: 'No Phone First Hour',
        description: 'Start the day without your phone',
        category: HabitCategory.productivity,
        icon: Icons.phone_android,
        colorValue: 0xFF607D8B,
        durationMinutes: 60,
      ),
    ],
    'Learning': [
      SuggestedHabit(
        id: 'learning-read',
        title: 'Read 20 Pages',
        description: 'Any book you enjoy',
        category: HabitCategory.learning,
        icon: Icons.menu_book,
        colorValue: 0xFF795548,
        durationMinutes: 20,
      ),
      SuggestedHabit(
        id: 'learning-language',
        title: 'Learn a Language',
        description: '15 minutes of practice',
        category: HabitCategory.learning,
        icon: Icons.school,
        colorValue: 0xFF00BCD4,
        durationMinutes: 15,
      ),
      SuggestedHabit(
        id: 'learning-course',
        title: 'Online Course',
        description: 'One lesson',
        category: HabitCategory.learning,
        icon: Icons.computer,
        colorValue: 0xFF9C27B0,
        frequency: HabitFrequency.weekly,
        weeklyDays: [
          DateTime.tuesday,
          DateTime.thursday,
          DateTime.saturday,
        ],
        durationMinutes: 30,
      ),
    ],
    'Finance': [
      SuggestedHabit(
        id: 'finance-expenses',
        title: 'Track Expenses',
        description: 'Note what you spent today',
        category: HabitCategory.finance,
        icon: Icons.savings,
        colorValue: 0xFF4CAF50,
        durationMinutes: 5,
      ),
      SuggestedHabit(
        id: 'finance-no-impulse',
        title: 'No Impulse Buys',
        description: 'Wait a day before buying extras',
        category: HabitCategory.finance,
        icon: Icons.shopping_cart,
        colorValue: 0xFFFF5722,
        durationMinutes: 5,
      ),
      SuggestedHabit(
        id: 'finance-budget-review',
        title: 'Weekly Budget Review',
        description: 'Check spending against your budget',
        category: HabitCategory.finance,
        icon: Icons.attach_money,
        colorValue: 0xFF009688,
        frequency: HabitFrequency.weekly,
        weeklyDays: [DateTime.sunday],
        durationMinutes: 15,
      ),
    ],
    'Mindfulness': [
      SuggestedHabit(
        id: 'mindfulness-meditate',
        title: 'Meditate',
        description: '10 minutes of quiet breathing',
        category: HabitCategory.mindfulness,
        icon: Icons.self_improvement,
        colorValue: 0xFF9C27B0,
        durationMinutes: 10,
      ),
      SuggestedHabit(
        id: 'mindfulness-gratitude',
        title: 'Gratitude Journal',
        description: 'Write 3 things you are grateful for',
        category: HabitCategory.mindfulness,
        icon: Icons.favorite,
        colorValue: 0xFFE91E63,
        durationMinutes: 5,
      ),
      SuggestedHabit(
        id: 'mindfulness-detox',
        title: 'Digital Detox Evening',
        description: 'No screens after 9 PM',
        category: HabitCategory.mindfulness,
        icon: Icons.spa,
        colorValue: 0xFF8BC34A,
        durationMinutes: 60,
      ),
    ],
  };
}
