import 'package:flutter/material.dart';

import 'glb_scene_viewer.dart';

/// Composable wrapper that adds a floating animation
/// around a [GlbSceneViewer].
///
/// Uses **composition** over inheritance — delegates rendering to
/// [GlbSceneViewer] (powered by O3D) while owning only the float animation.
class AnimatedRoomScene extends StatefulWidget {
  /// Path to the GLB asset (forwarded to [GlbSceneViewer]).
  final String assetPath;

  /// Max vertical displacement (in logical pixels) for the float.
  final double floatOffset;

  /// Duration of one full float cycle (up → down).
  final Duration floatDuration;

  const AnimatedRoomScene({
    super.key,
    required this.assetPath,
    this.floatOffset = 15.0,
    this.floatDuration = const Duration(seconds: 4),
  });

  @override
  State<AnimatedRoomScene> createState() => _AnimatedRoomSceneState();
}

class _AnimatedRoomSceneState extends State<AnimatedRoomScene>
    with SingleTickerProviderStateMixin {
  // ── Float Animation (Up ↔ Down) ──
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: widget.floatDuration,
    );

    _floatAnimation = CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOutSine,
    );

    // Start floating immediately
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final yOffset = -widget.floatOffset +
            (_floatAnimation.value * widget.floatOffset * 2);

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: child,
        );
      },
      child: GlbSceneViewer(
        assetPath: widget.assetPath,
      ),
    );
  }
}
