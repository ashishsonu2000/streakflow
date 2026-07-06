import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_search_provider.dart';

class HabitSearchBar extends ConsumerWidget {
  const HabitSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: SearchBar(
        hintText: "Search habits",
        leading: const Icon(Icons.search),
        onChanged: (value) {
          ref.read(habitSearchProvider.notifier).state = value;
        },
      ),
    );
  }
}
