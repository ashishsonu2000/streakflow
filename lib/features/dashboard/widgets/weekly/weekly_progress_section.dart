import 'package:flutter/material.dart';

import '../../domain/models/weekly_progress.dart';
import '../sections/section_title.dart';
import 'day_progress.dart';

class WeeklyProgressSection extends StatelessWidget {
  final List<WeeklyProgress> weekly;

  const WeeklyProgressSection({
    super.key,
    required this.weekly,
  });

  @override
  Widget build(BuildContext context) {
    final completed = weekly.where((e) => e.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Weekly Progress",
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekly
                      .map(
                        (e) => DayProgress(
                          progress: e,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  "$completed / ${weekly.length} Days Completed",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
