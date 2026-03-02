import 'package:flutter/material.dart';

import 'star_painter.dart';
import 'star.dart';
import 'shooting_star.dart';

/// Un fondo animado espacial con gradiente azul profundo, estrellas parpadeantes,
/// y estrellas fugaces.
class AnimatedStarryBackground extends StatefulWidget {
  final Widget? child;
  const AnimatedStarryBackground({super.key, this.child});

  @override
  State<AnimatedStarryBackground> createState() => _AnimatedStarryBackgroundState();
}

class _AnimatedStarryBackgroundState extends State<AnimatedStarryBackground> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shootingController;
  late List<Star> _stars;
  late List<ShootingStar> _shootingStars;
  final int _starCount = 120;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 60)
    )..repeat(reverse: true); 

    _shootingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), 
    )..repeat();

    _stars = List.generate(_starCount, (index) => Star());
    _shootingStars = List.generate(8, (index) => ShootingStar());
  }

  @override
  void dispose() {
    _controller.dispose();
    _shootingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF01000A), // Espacio hiper oscuro puro negro/azul
            Color(0xFF020316), // Azul noche mega profundo
            Color(0xFF040828), // Comienzo del degradado estelar
            Color(0xFF002B99), // Azul fuerte focalizado
            Color(0xFF0055FF), // Resplandor azul galáctico en la base
          ],
          stops: [0.0, 0.40, 0.65, 0.85, 1.0], // Se aclara un poco antes y más suavemente
        ),
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _shootingController]),
        builder: (context, child) {
          return CustomPaint(
            painter: StarPainter(
              _stars, 
              _shootingStars, 
              _controller.value, 
              _shootingController.value
            ),
            size: Size.infinite,
            child: widget.child,
          );
        },
      ),
    );
  }
}

