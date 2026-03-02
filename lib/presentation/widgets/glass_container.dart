import 'dart:ui';

import 'package:flutter/material.dart';

/// Glassmorphism container with an optional [progress] parameter.
///
/// - `progress = 1.0` (default): fully materialized glass effect.
/// - `progress = 0.0`: completely transparent / invisible.
///
/// Use the [progress] parameter for scroll-driven or animated transitions.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final double blur;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  /// Controls the materialization level from 0.0 (invisible) to 1.0 (full glass).
  final double progress;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.opacity = 0.1,
    this.blur = 10.0,
    this.padding = const EdgeInsets.all(24.0),
    this.margin,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final effectiveOpacity = opacity * progress;
    final effectiveBlur = blur * progress;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1 * progress),
            blurRadius: 20 * progress,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: Container(
            padding: padding,
            constraints: progress < 1.0
                ? const BoxConstraints(minHeight: 56)
                : null,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: effectiveOpacity),
              borderRadius: radius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2 * progress),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
