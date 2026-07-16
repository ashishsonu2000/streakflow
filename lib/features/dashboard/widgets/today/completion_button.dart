import 'package:flutter/material.dart';

class CompletionButton extends StatelessWidget {
  const CompletionButton({
    super.key,
    required this.completed,
    this.onPressed,
  });

  final bool completed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: completed ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: completed ? color : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 24,
        onPressed: onPressed,
        icon: Icon(
          Icons.check,
          color: completed ? Colors.white : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
