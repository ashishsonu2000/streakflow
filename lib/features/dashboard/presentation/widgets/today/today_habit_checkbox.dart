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
    return Semantics(
      button: true,
      checked: completed,
      label: completed
          ? 'Habit completed'
          : 'Complete habit',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            // ---------------------------------------------------------
            // COMPLETED
            // ---------------------------------------------------------

            color: completed
                ? const Color(0xFF4CAF50)
                : Colors.transparent,

            border: Border.all(
              color: completed
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFB8B8BE),
              width: completed ? 1 : 1.7,
            ),

            boxShadow: completed
                ? [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(
                  alpha: 0.18,
                ),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: completed
                ? const Icon(
              Icons.check_rounded,
              key: ValueKey('completed'),
              color: Colors.white,
              size: 20,
            )
                : const SizedBox(
              key: ValueKey('incomplete'),
            ),
          ),
        ),
      ),
    );
  }
}