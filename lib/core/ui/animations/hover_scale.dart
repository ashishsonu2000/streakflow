import 'package:flutter/material.dart';

class HoverScale extends StatefulWidget {
  final Widget child;

  const HoverScale({
    super.key,
    required this.child,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: hover ? 1.02 : 1,
        child: widget.child,
      ),
    );
  }
}
