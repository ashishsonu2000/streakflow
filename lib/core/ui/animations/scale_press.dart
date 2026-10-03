import 'package:flutter/material.dart';

class ScalePress extends StatefulWidget {
  const ScalePress({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<ScalePress> createState() => _ScalePressState();
}

class _ScalePressState extends State<ScalePress> {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => scale = .98);
      },
      onTapCancel: () {
        setState(() => scale = 1);
      },
      onTapUp: (_) {
        setState(() => scale = 1);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
