import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class AppProgressBar extends StatefulWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercentage = true,
    this.height = 10,
    this.color,
    this.enableShimmer = true,
  });

  final double value;
  final String? label;
  final bool showPercentage;
  final double height;
  final Color? color;
  final bool enableShimmer;

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  /// 🔥 Call this when XP updates
  void triggerXPAnimation() {
    _shimmerController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.value.clamp(0.0, 1.0);
    final theme = Theme.of(context);
    final progressColor = widget.color ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Label Row
        if (widget.label != null || widget.showPercentage)
          Row(
            children: [
              if (widget.label != null)
                Expanded(
                  child: Text(
                    widget.label!,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              if (widget.showPercentage)
                Text(
                  "${(progress * 100).round()}%",
                  style: theme.textTheme.labelMedium,
                ),
            ],
          ),

        if (widget.label != null || widget.showPercentage)
          const SizedBox(height: AppSpacing.sm),

        /// 🔥 Animated Bar
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, _) {
            return Stack(
              children: [
                /// Background
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Container(
                    height: widget.height,
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),

                /// Progress Gradient
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            width: constraints.maxWidth * animatedValue,
                            height: widget.height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  progressColor.withOpacity(0.8),
                                  progressColor,
                                  progressColor.withOpacity(0.9),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: progressColor.withOpacity(0.4),
                                  blurRadius: 12,
                                )
                              ],
                            ),
                          ),

                          /// ✨ Shimmer Effect
                          if (widget.enableShimmer)
                            AnimatedBuilder(
                              animation: _shimmerController,
                              builder: (_, __) {
                                return Positioned(
                                  left: (constraints.maxWidth *
                                      _shimmerController.value) -
                                      40,
                                  child: Container(
                                    width: 40,
                                    height: widget.height,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}