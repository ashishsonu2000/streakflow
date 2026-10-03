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
    const blue = Color(0xFF2563EB);

    return Semantics(
      button: true,
      checked: completed,
      label: completed
          ? 'Completed'
          : 'Complete habit',
      child: InkWell(
        onTap: onPressed,
        borderRadius:
        BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOutCubic,

          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: completed
                ? blue
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(14),

            border: Border.all(
              color: completed
                  ? blue
                  : const Color(0xFFCBD5E1),
              width: 2,
            ),

            boxShadow: completed
                ? [
              BoxShadow(
                color: blue.withValues(
                  alpha: 0.20,
                ),
                blurRadius: 10,
                offset:
                const Offset(0, 4),
              ),
            ]
                : null,
          ),

          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 180,
            ),
            transitionBuilder:
                (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: completed
                ? const Icon(
              Icons.check_rounded,
              key: ValueKey(
                'completed',
              ),
              color: Colors.white,
              size: 25,
            )
                : const SizedBox(
              key: ValueKey(
                'pending',
              ),
            ),
          ),
        ),
      ),
    );
  }
}