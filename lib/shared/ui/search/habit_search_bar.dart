import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/habits/presentation/provider/habit_search_provider.dart';

class HabitSearchBar extends ConsumerWidget {
  const HabitSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(habitSearchProvider);

    return SearchBar(
      hintText: "Search habits...",
      leading: const Icon(Icons.search),
      trailing: search.isEmpty
          ? null
          : [
              IconButton(
                onPressed: () {
                  ref.read(habitSearchProvider.notifier).state = '';
                },
                icon: const Icon(Icons.close),
              )
            ],
      onChanged: (value) {
        ref.read(habitSearchProvider.notifier).state = value;
      },
    );
  }
}
