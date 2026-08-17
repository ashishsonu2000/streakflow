import 'package:flutter/material.dart';

class GoalChip extends StatelessWidget {
  const GoalChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;

  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context,
      ) {
    return FilterChip(
      label: Text(
        label,
      ),
      selected: selected,
      onSelected: (_) {
        onTap();
      },
    );
  }
}