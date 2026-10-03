import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class AppProgressBar extends StatefulWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercentage = true,
    this.height = 9,
    this.color,
    this.enableShimmer = true,

    // Optional styling for different surfaces.
    this.labelColor,
    this.percentageColor,
    this.backgroundColor,
  });

  final double value;
  final String? label;
  final bool showPercentage;
  final double height;
  final Color? color;
  final bool enableShimmer;

  /// Optional label color.
  final Color? labelColor;

  /// Optional percentage color.
  final Color? percentageColor;

  /// Optional progress track color.
  final Color? backgroundColor;

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.enableShimmer) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AppProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enableShimmer && !oldWidget.enableShimmer) {
      _shimmerController.repeat();
    } else if (!widget.enableShimmer && oldWidget.enableShimmer) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void triggerXPAnimation() {
    if (!widget.enableShimmer) {
      return;
    }

    _shimmerController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.value.clamp(0.0, 1.0);

    final theme = Theme.of(context);

    final progressColor =
        widget.color ?? theme.colorScheme.primary;

    final labelColor =
        widget.labelColor ?? theme.textTheme.labelMedium?.color;

    final percentageColor =
        widget.percentageColor ?? theme.textTheme.labelMedium?.color;

    final trackColor =
        widget.backgroundColor ??
            theme.colorScheme.surfaceContainerHighest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =============================================================
        // LABEL + PERCENTAGE
        // =============================================================

        if (widget.label != null || widget.showPercentage)
          Row(
            children: [
              if (widget.label != null)
                Expanded(
                  child: Text(
                    widget.label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),

              if (widget.showPercentage)
                Text(
                  '${(progress * 100).round()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: percentageColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
            ],
          ),

        if (widget.label != null || widget.showPercentage)
          const SizedBox(height: AppSpacing.sm),

        // =============================================================
        // ANIMATED XP BAR
        // =============================================================

        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 0,
            end: progress,
          ),
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.round),
              child: SizedBox(
                height: widget.height,
                width: double.infinity,
                child: Stack(
                  children: [
                    // -------------------------------------------------
                    // TRACK
                    // -------------------------------------------------

                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: trackColor,
                        ),
                      ),
                    ),

                    // -------------------------------------------------
                    // PROGRESS
                    // -------------------------------------------------

                    FractionallySizedBox(
                      widthFactor: animatedValue,
                      child: Container(
                        height: widget.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              progressColor.withValues(alpha: 0.85),
                              progressColor,
                              progressColor.withValues(alpha: 0.92),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: progressColor.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // -------------------------------------------------
                    // SHIMMER
                    // -------------------------------------------------

                    if (widget.enableShimmer && animatedValue > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: animatedValue,
                          child: AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: 1,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: -40 +
                                          (_shimmerController.value *
                                              120),
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withValues(
                                                alpha: 0.42,
                                              ),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // -------------------------------------------------
                    // PROGRESS END GLOW
                    // -------------------------------------------------

                    if (animatedValue > 0)
                      Align(
                        alignment: Alignment(
                          -1 + (animatedValue * 2),
                          0,
                        ),
                        child: Container(
                          width: 3,
                          height: widget.height,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(
                              AppRadius.round,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}