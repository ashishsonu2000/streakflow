import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/calendar_day_view_model.dart';

class DayDetailsSheet extends StatelessWidget {
  const DayDetailsSheet({
    super.key,
    required this.day,
  });

  final CalendarDayViewModel day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final completionRate = day.totalHabits == 0
        ? 0
        : (day.completedHabits / day.totalHabits * 100).round();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------
            // Header
            //----------------------------------------
            Text(
              DateFormat.yMMMMEEEEd().format(day.date),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            //----------------------------------------
            // Completion Summary
            //----------------------------------------
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: const Text("Completion"),
                subtitle: Text(
                  "$completionRate% Completed",
                ),
                trailing: Text(
                  "${day.completedHabits}/${day.totalHabits}",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),

            const SizedBox(height: 12),

            //----------------------------------------
            // Activity Level
            //----------------------------------------
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_fire_department),
                title: const Text("Activity Level"),
                trailing: Text(
                  "${day.intensity}/4",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),

            const SizedBox(height: 24),

            //----------------------------------------
            // Logs
            //----------------------------------------
            Text(
              "Habit Logs",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (day.habits.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    "No habit activity for this day.",
                  ),
                ),
              )
            else
              ...day.habits.map(
                (habit) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text(
                      habit.title,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (habit.notes.isNotEmpty) Text(habit.notes),
                        if (habit.completedAt != null)
                          Text(
                            DateFormat.jm().format(
                              habit.completedAt!,
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "+${habit.xpEarned}",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("XP"),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
