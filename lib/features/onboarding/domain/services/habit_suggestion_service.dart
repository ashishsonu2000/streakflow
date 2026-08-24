import '../models/suggested_habit.dart';

class HabitSuggestionService {
  const HabitSuggestionService();

  List<SuggestedHabit> getSuggestions(
      List<String> goals,
      ) {
    final suggestions = <SuggestedHabit>[];

    if (goals.contains('Health')) {
      suggestions.addAll([
        const SuggestedHabit(
          title: 'Drink Water',
          description: '8 glasses every day',
          category: 'Health',
        ),
        const SuggestedHabit(
          title: 'Morning Walk',
          description: '30 minutes',
          category: 'Health',
        ),
      ]);
    }

    if (goals.contains('Fitness')) {
      suggestions.addAll([
        const SuggestedHabit(
          title: 'Running',
          description: '20 minutes',
          category: 'Fitness',
        ),
        const SuggestedHabit(
          title: 'Stretching',
          description: '10 minutes',
          category: 'Fitness',
        ),
      ]);
    }

    if (goals.contains('Productivity')) {
      suggestions.addAll([
        const SuggestedHabit(
          title: 'Reading',
          description: '30 pages',
          category: 'Productivity',
        ),
        const SuggestedHabit(
          title: 'Deep Work',
          description: '90-minute focus session',
          category: 'Productivity',
        ),
      ]);
    }

    if (goals.contains('Mindfulness')) {
      suggestions.addAll([
        const SuggestedHabit(
          title: 'Meditation',
          description: '10 minutes',
          category: 'Mindfulness',
        ),
      ]);
    }

    return suggestions;
  }
}