import 'package:flutter/material.dart';

import '../../../app/theme/app_radius.dart';

class AppProgressBar extends StatefulWidget {
  final double value;
  final String? label;
  final double height;
  final bool showPercentage;
  final Duration duration;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 10,
    this.showPercentage = true,
    this.duration = const Duration(milliseconds: 900),
    this.label,
  });

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  double _oldValue = 0;

  @override
  void initState() {
    super.initState();

    /// ✨ Shimmer animation (loop)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _oldValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant AppProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 🚀 Detect XP gain
    if (widget.value > _oldValue) {
      _triggerXPAnimation();
    }

    _oldValue = widget.value;
  }

  void _triggerXPAnimation() {
    /// 🔥 Quick bounce effect (premium feel)
    _shimmerController.forward(from: 0);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 HEADER
        if (widget.label != null || widget.showPercentage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: const TextStyle(color: Colors.white70),
                ),
              if (widget.showPercentage)
                Text(
                  "${(progress * 100).round()}%",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

        const SizedBox(height: 10),

        /// 🌈 ANIMATED BAR
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return Stack(
              children: [
                /// 🔹 Background
                Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(AppRadius.round),
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),

                /// 🌈 Gradient Progress
                FractionallySizedBox(
                  widthFactor: animatedValue,
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        height: widget.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppRadius.round),

                          /// 🔥 Gradient + Shimmer
                          gradient: LinearGradient(
                            begin: Alignment(-1 + _shimmerController.value * 2,
                                0),
                            end: Alignment(
                                1 + _shimmerController.value * 2, 0),
                            colors: const [
                              Color(0xffFFD54F),
                              Color(0xffFF8A65),
                              Color(0xffFFD54F),
                            ],
                          ),

                          /// ✨ Glow
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.6),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
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