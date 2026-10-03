import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/domain/enums/habit_frequency.dart';
import '../../../habits/domain/models/create_habit_request.dart';
import '../../../habits/domain/models/habit_category.dart';
import '../../../habits/domain/usecases/complete_habit_usecase.dart';
import '../../../habits/domain/usecases/create_habit_usecase.dart';
import '../../../habits/presentation/provider/habit_providers.dart';

class GenerateTestDataTile extends ConsumerWidget {
  const GenerateTestDataTile({
    super.key,
  });

  // ===============================================================
  // SAMPLE HABITS
  //
  // A small, varied set - daily and weekly, a mix of categories -
  // so the dashboard, habit list, and statistics all have something
  // realistic to show without clicking through the UI by hand.
  // ===============================================================

  static final List<_SampleHabit> _sampleHabits = [
    _SampleHabit(
      title: 'Morning Run',
      category: HabitCategory.fitness,
      icon: Icons.directions_run,
      color: const Color(0xFFF97316),
      frequency: HabitFrequency.daily,
      // Misses roughly one day in five.
      shouldCompleteDay: (dayIndex) => dayIndex % 5 != 0,
    ),
    _SampleHabit(
      title: 'Read 20 Pages',
      category: HabitCategory.study,
      icon: Icons.menu_book,
      color: const Color(0xFF2563EB),
      frequency: HabitFrequency.daily,
      // More frequent misses - a moderate, broken streak.
      shouldCompleteDay: (dayIndex) => dayIndex % 3 != 0,
    ),
    _SampleHabit(
      title: 'Drink Water',
      category: HabitCategory.health,
      icon: Icons.local_drink,
      color: const Color(0xFF06B6D4),
      frequency: HabitFrequency.daily,
      // Complete every day - a strong ongoing streak.
      shouldCompleteDay: (dayIndex) => true,
    ),
    _SampleHabit(
      title: 'Meditate',
      category: HabitCategory.mindfulness,
      icon: Icons.self_improvement,
      color: const Color(0xFF9333EA),
      frequency: HabitFrequency.weekly,
      weeklyDays: const [1, 3, 5],
      // Skip one scheduled occurrence out of every four.
      shouldCompleteDay: (occurrenceIndex) => occurrenceIndex % 4 != 0,
    ),
    _SampleHabit(
      title: 'Weekly Planning',
      category: HabitCategory.productivity,
      icon: Icons.event_note,
      color: const Color(0xFF0D9488),
      frequency: HabitFrequency.weekly,
      weeklyDays: const [1],
      shouldCompleteDay: (occurrenceIndex) => true,
    ),
  ];

  static const int _historyDays = 28;

  Future<void> _generate(
      BuildContext context,
      WidgetRef ref,
      ) async {
    try {
      final createHabit = ref.read(createHabitUseCaseProvider);
      final completeHabit = ref.read(completeHabitUseCaseProvider);

      final today = DateTime.now();
      final startDate = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(
        const Duration(days: _historyDays),
      );

      var habitsCreated = 0;
      var completionsCreated = 0;

      for (final sample in _sampleHabits) {
        final habitId = await _createSampleHabit(
          createHabit,
          sample,
          startDate,
        );

        habitsCreated++;

        completionsCreated += await _generateCompletions(
          completeHabit,
          habitId,
          sample,
          startDate,
          today,
        );
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Created $habitsCreated sample habits '
            'with $completionsCreated completions.',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to generate test data.\n$error',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  // ===============================================================
  // CREATE HABIT
  // ===============================================================

  Future<String> _createSampleHabit(
      CreateHabitUseCase createHabit,
      _SampleHabit sample,
      DateTime startDate,
      ) async {
    final habit = await createHabit(
      CreateHabitRequest(
        title: sample.title,
        category: sample.category,
        frequency: sample.frequency,
        iconCodePoint: sample.icon.codePoint,
        colorValue: sample.color.toARGB32(),
        weeklyDays: sample.weeklyDays,
        startDate: startDate,
      ),
    );

    return habit.id;
  }

  // ===============================================================
  // GENERATE COMPLETIONS
  // ===============================================================

  Future<int> _generateCompletions(
      CompleteHabitUseCase completeHabit,
      String habitId,
      _SampleHabit sample,
      DateTime startDate,
      DateTime today,
      ) async {
    var occurrenceIndex = 0;
    var completions = 0;

    for (
    var day = startDate;
    !day.isAfter(today);
    day = day.add(const Duration(days: 1))
    ) {
      final isScheduled = sample.frequency == HabitFrequency.daily ||
          sample.weeklyDays.contains(day.weekday);

      if (!isScheduled) {
        continue;
      }

      final shouldComplete = sample.shouldCompleteDay(
        occurrenceIndex,
      );

      occurrenceIndex++;

      if (!shouldComplete) {
        continue;
      }

      await completeHabit(
        habitId,
        date: day,
      );

      completions++;
    }

    return completions;
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return ListTile(
      leading: const Icon(
        Icons.science_outlined,
      ),
      title: const Text(
        'Generate Test Data',
      ),
      subtitle: const Text(
        'Populate habits with sample statistics',
      ),
      onTap: () {
        _generate(
          context,
          ref,
        );
      },
    );
  }
}

// =====================================================================
// SAMPLE HABIT DEFINITION
// =====================================================================

class _SampleHabit {
  const _SampleHabit({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.shouldCompleteDay,
    this.weeklyDays = const [],
  });

  final String title;
  final HabitCategory category;
  final IconData icon;
  final Color color;
  final HabitFrequency frequency;
  final List<int> weeklyDays;

  /// Whether the [occurrenceIndex]-th scheduled occurrence (0-based,
  /// counting only days the habit is actually due) should be marked
  /// completed.
  final bool Function(int occurrenceIndex) shouldCompleteDay;
}
