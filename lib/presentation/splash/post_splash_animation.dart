import 'dart:math' as math;

import 'package:flutter/material.dart';

class PostSplashAnimation extends StatefulWidget {
  const PostSplashAnimation({
    super.key,
    required this.onFinished,
  });

  final VoidCallback onFinished;

  @override
  State<PostSplashAnimation> createState() => _PostSplashAnimationState();
}

class _PostSplashAnimationState extends State<PostSplashAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _intro;
  late final Animation<double> _logo;
  late final Animation<double> _copy;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _intro = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.28,
        curve: Curves.easeOut,
      ),
    );

    _logo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.08,
        0.62,
        curve: Curves.easeOutBack,
      ),
    );

    _copy = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.28,
        0.72,
        curve: Curves.easeOut,
      ),
    );

    _glow = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.30,
        1.0,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    Future<void>.delayed(
      const Duration(milliseconds: 2300),
          () {
        if (!mounted) return;

        widget.onFinished();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020B2B),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final pulse =
              1.0 +
                  0.025 *
                      math.sin(
                        _controller.value * math.pi * 4,
                      );

          return Stack(
            fit: StackFit.expand,
            children: [
              const _FlowBackground(),

              Center(
                child: FadeTransition(
                  opacity: _intro,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _logo.value * pulse,
                        child: Container(
                          width: 154,
                          height: 154,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(38),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2388FF)
                                    .withValues(
                                  alpha:
                                  0.18 +
                                      _glow.value * 0.18,
                                ),
                                blurRadius: 42,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(38),
                            child: Image.asset(
                              'assets/branding/app_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      FadeTransition(
                        opacity: _copy,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.18),
                            end: Offset.zero,
                          ).animate(_copy),
                          child: Column(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 31,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.8,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'STREAK ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'FLOW',
                                      style: TextStyle(
                                        color: Color(0xFF35B9FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Small steps. Big change.',
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: 0.82,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class _FlowBackground extends StatelessWidget {
  const _FlowBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FlowPainter(),
      child: const SizedBox.expand(),
    );
  }
}


class _FlowPainter extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final rect = Offset.zero & size;

    // Background gradient
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF020B2B),
          Color(0xFF06143F),
          Color(0xFF092B75),
        ],
      ).createShader(rect);

    canvas.drawRect(
      rect,
      backgroundPaint,
    );

    // Flowing blue lines
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..color = const Color(0xFF2388FF)
          .withValues(alpha: 0.16);

    for (var i = 0; i < 9; i++) {
      final path = Path();

      final y =
          size.height * (0.68 + i * 0.035);

      path.moveTo(
        -20,
        y,
      );

      path.cubicTo(
        size.width * 0.25,
        y - 55 - i * 2,
        size.width * 0.45,
        y + 65,
        size.width * 0.70,
        y - 18,
      );

      path.cubicTo(
        size.width * 0.86,
        y - 50,
        size.width * 0.95,
        y + 15,
        size.width + 20,
        y - 20,
      );

      canvas.drawPath(
        path,
        wavePaint,
      );
    }

    // Flowing river
    final river = Path();

    river.moveTo(
      size.width * 0.50,
      size.height,
    );

    river.cubicTo(
      size.width * 0.40,
      size.height * 0.94,
      size.width * 0.64,
      size.height * 0.89,
      size.width * 0.48,
      size.height * 0.84,
    );

    river.cubicTo(
      size.width * 0.36,
      size.height * 0.80,
      size.width * 0.56,
      size.height * 0.76,
      size.width * 0.50,
      size.height * 0.72,
    );

    final riverPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = const LinearGradient(
        colors: [
          Color(0x001CA8FF),
          Color(0xFF5ED7FF),
          Color(0x001CA8FF),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          size.height * 0.70,
          size.width,
          size.height * 0.30,
        ),
      );

    canvas.drawPath(
      river,
      riverPaint,
    );

    // Horizon glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF6BCBFF)
              .withValues(alpha: 0.18),
          const Color(0xFF1B73FF)
              .withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.5,
            size.height * 0.82,
          ),
          radius: size.width * 0.50,
        ),
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.5,
        size.height * 0.82,
      ),
      size.width * 0.50,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}