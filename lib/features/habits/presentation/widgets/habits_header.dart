import 'package:flutter/material.dart';

class HabitsHeader extends StatelessWidget {
  const HabitsHeader({
    super.key,
    required this.onCreateHabit,
  });

  final VoidCallback onCreateHabit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        14,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          // =========================================================
          // HEADER
          // =========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'My Habits',
                  style: theme
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                    color: const Color(
                      0xFF0F172A,
                    ),
                    fontWeight:
                    FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Build consistency, one day at a time',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: const Color(
                      0xFF64748B,
                    ),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // =========================================================
          // ADD HABIT
          // =========================================================

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCreateHabit,
              borderRadius:
              BorderRadius.circular(999),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  // Light blue surface
                  color: const Color(
                    0xFFEFF6FF,
                  ),

                  // Blue border
                  border: Border.all(
                    color: const Color(
                      0xFFBFDBFE,
                    ),
                    width: 1.2,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF172554,
                      ).withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 8,
                      offset: const Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Color(
                    0xFF172554,
                  ),
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}