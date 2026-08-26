import 'package:flutter/material.dart';

class HeroStats extends StatelessWidget {
  const HeroStats({
    super.key,
    required this.completed,
    required this.total,
    this.best,
    this.target,
  });

  final int completed;
  final int total;

  // Kept optional for compatibility with existing callers.
  final int? best;
  final int? target;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0
        ? 0.0
        : (completed / total).clamp(0.0, 1.0);

    final percentage = (progress * 100).round();

    return Row(
      children: [
        Expanded(
          child: _Stat(
            icon: Icons.check_circle_rounded,
            value: '$completed / $total',
            label: 'Today',
          ),
        ),

        Container(
          width: 1,
          height: 36,
          color: Colors.white.withValues(
            alpha: 0.18,
          ),
        ),

        Expanded(
          child: _Stat(
            icon: Icons.percent_rounded,
            value: '$percentage%',
            label: 'Progress',
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white70,
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}