import 'package:flutter/material.dart';

class TodayHabitCheckbox extends StatelessWidget {
  const TodayHabitCheckbox({
    super.key,
    required this.completed,
    this.onPressed,
  });

  final bool completed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: completed ? Colors.green : Colors.transparent,
          border: Border.all(
            color: completed ? Colors.green : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: completed
              ? const Icon(
                  Icons.check,
                  key: ValueKey(true),
                  color: Colors.white,
                  size: 20,
                )
              : const SizedBox(
                  key: ValueKey(false),
                ),
        ),
      ),
    );
  }
}
