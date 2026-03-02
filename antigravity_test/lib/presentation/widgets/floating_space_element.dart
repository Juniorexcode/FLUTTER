import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Un elemento flotante en el espacio (Luna, Saturno, Chico 2.5D, etc.)
/// Aplica BlendMode.screen para fusionar fondos negros generados y oscilar suavemente.
class FloatingSpaceElement extends StatefulWidget {
  final Widget child;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final int durationSeconds;
  final bool reverseRotate;
  final double maxOscillation;

  const FloatingSpaceElement({
    super.key,
    required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.durationSeconds,
    this.reverseRotate = false,
    this.maxOscillation = 20.0,
  });

  @override
  State<FloatingSpaceElement> createState() => _FloatingSpaceElementState();
}

class _FloatingSpaceElementState extends State<FloatingSpaceElement> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Movimiento de levitación vertical fluido usando seno
          final double dy = math.sin(_controller.value * 2 * math.pi) * widget.maxOscillation;
          
          // Rotación sutil
          final double angle = math.sin(_controller.value * 2 * math.pi) * 0.05 * (widget.reverseRotate ? -1 : 1);

          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.rotate(
              angle: angle,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
