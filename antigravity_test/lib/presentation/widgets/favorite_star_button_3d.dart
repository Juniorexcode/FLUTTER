import 'dart:math' as math;
import 'package:flutter/material.dart';

class FavoriteStarButton3D extends StatefulWidget {
  final double hover;

  const FavoriteStarButton3D({super.key, required this.hover});

  @override
  State<FavoriteStarButton3D> createState() => _FavoriteStarButton3DState();
}

class _FavoriteStarButton3DState extends State<FavoriteStarButton3D> with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite) {
      _anim.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Elevación (baseZ = hover * 35.0) ha sido movida al _buildLayer del padre 
    // para garantizar colisiones perfectas bajo perspectiva 3D real.

    return Positioned(
      top: 20,
      right: 20,
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                // Shaking vibrante (seno amortiguado rápido)
                final shake = math.sin(_anim.value * math.pi * 6) * (1 - _anim.value) * 0.4;
                // Pop de escala
                final scale = 1.0 + math.sin(_anim.value * math.pi) * 0.4;

                // Matriz para la estrella, reemplazando deprecated methods
                final starTransform = Matrix4.identity()
                  ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0))
                  ..rotateZ(shake);

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Mini estrellas festivas alrededor (Sólo visibles durante el encendido)
                    if (_isFavorite && _anim.value > 0 && _anim.value < 1)
                      ...List.generate(6, (i) {
                        final angle = (i / 6) * math.pi * 2;
                        final distance = 15.0 + (_anim.value * 25.0); // Se expanden hasta 40px
                        final opacity = 1.0 - _anim.value;
                        return Transform(
                          transform: Matrix4.translationValues(
                            math.cos(angle) * distance,
                            math.sin(angle) * distance,
                            0.0,
                          ),
                          child: Opacity(
                            opacity: opacity,
                            child: const Icon(Icons.star, color: Colors.yellowAccent, size: 10),
                          ),
                        );
                      }),
                    
                    // Botón de estrella central
                    Transform(
                      alignment: Alignment.center,
                      transform: starTransform,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isFavorite 
                              ? Colors.white.withValues(alpha: 0.95) 
                              : Colors.white.withValues(alpha: 0.2),
                          boxShadow: _isFavorite ? [
                            BoxShadow(
                              color: Colors.yellowAccent.withValues(alpha: 0.6), 
                              blurRadius: 15, 
                              spreadRadius: 2
                            )
                          ] : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Icon(
                          _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                          color: _isFavorite ? const Color(0xFFFFB300) : Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
    );
  }
}
