import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habits_view_provider.dart';

class HabitSearchBar extends ConsumerWidget {
  const HabitSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsViewProvider);

    return SearchBar(
      hintText: "Search habits...",
      leading: const Icon(Icons.search),
      trailing: state.search.isEmpty
          ? null
          : [
              IconButton(
                onPressed: () {
                  ref
                      .read(
                        habitsViewProvider.notifier,
                      )
                      .clearSearch();
                },
                icon: const Icon(Icons.close),
              ),
            ],
      onChanged: (value) {
        ref.read(habitsViewProvider.notifier).setSearch(value);
      },
    );
  }
}
