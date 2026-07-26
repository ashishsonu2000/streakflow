import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/habits_view_provider.dart';

class HabitSearchBar extends ConsumerWidget {
  const HabitSearchBar({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search habits',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          ref.read(habitsViewProvider.notifier).setSearch(value);
        },
      ),
    );
  }
}
