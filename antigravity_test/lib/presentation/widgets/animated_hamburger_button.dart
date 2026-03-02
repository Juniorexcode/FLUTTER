import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Un botón de menú hamburguesa customizado que emula una animación fluida
/// proveniente de CSS puro. Alterna entre tres líneas paralelas y una flecha.
/// Un botón de menú hamburguesa customizado que emula una animación fluida
/// proveniente de CSS puro. Alterna entre tres líneas paralelas y una flecha (o X).
class AnimatedHamburgerButton extends StatefulWidget {
  /// Define si el botón muestra el estado "abierto" (flecha/cruz) o "cerrado" (hamburguesa).
  final bool isOpened;
  final VoidCallback onTap;

  const AnimatedHamburgerButton({
    super.key,
    required this.isOpened,
    required this.onTap,
  });

  @override
  State<AnimatedHamburgerButton> createState() => _AnimatedHamburgerButtonState();
}

class _AnimatedHamburgerButtonState extends State<AnimatedHamburgerButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    const curve = Curves.easeInOut;

    // Constantes escaladas a la mitad del CSS original (70x58 -> 35x29)
    const double width = 35.0;
    const double lineH = 3.0;

    // Efecto glow "Dinámico" en hover
    final List<BoxShadow> glowShadows = _isHovering
        ? [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 10,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              blurRadius: 15,
              spreadRadius: 4,
            ),
          ]
        : [];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: 29.0,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              // --- LÍNEA 1 ---
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                top: 0,
                left: 0,
                child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  width: width,
                  height: lineH,
                  alignment: Alignment.center,
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: glowShadows,
                    borderRadius: widget.isOpened
                        ? const BorderRadius.horizontal(left: Radius.circular(25))
                        : BorderRadius.circular(25),
                  ),
                  transform: widget.isOpened
                      ? (Matrix4.identity()
                        ..rotateZ(35 * math.pi / 180)
                        ..multiply(Matrix4.diagonal3Values(0.55, 1.0, 1.0))
                        ..multiply(Matrix4.translationValues(19.5, -2.25, 0.0)))
                      : Matrix4.identity(),
                ),
              ),
              
              // --- LÍNEA 2 ---
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                top: 9.0,
                left: 0,
                child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  width: widget.isOpened ? 22.5 : width,
                  height: lineH,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: glowShadows,
                    borderRadius: widget.isOpened
                        ? const BorderRadius.horizontal(right: Radius.circular(25))
                        : BorderRadius.circular(25),
                  ),
                ),
              ),
              
              // --- LÍNEA 3 ---
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                top: 18.0,
                left: 0,
                child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  width: width,
                  height: lineH,
                  alignment: Alignment.center,
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: glowShadows,
                    borderRadius: widget.isOpened
                        ? const BorderRadius.horizontal(left: Radius.circular(25))
                        : BorderRadius.circular(25),
                  ),
                  transform: widget.isOpened
                      ? (Matrix4.identity()
                        ..rotateZ(-35 * math.pi / 180)
                        ..multiply(Matrix4.diagonal3Values(0.55, 1.0, 1.0))
                        ..multiply(Matrix4.translationValues(19.5, 2.25, 0.0)))
                      : Matrix4.identity(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
