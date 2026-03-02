import 'dart:math' as math;
import 'package:flutter/material.dart';

/// SolarSystemLoader: Animación celestial nativa en Dart/Flutter.
/// Versión mejorada con controladores independientes para fluidez total.
class SolarSystemLoader extends StatefulWidget {
  const SolarSystemLoader({super.key});

  @override
  State<SolarSystemLoader> createState() => _SolarSystemLoaderState();
}

class _SolarSystemLoaderState extends State<SolarSystemLoader> with TickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Sol (Central)
          _buildSun(),

          // Órbitas y Planetas con tiempos exactos del CSS
          OrbitingPlanet(
            radius: 40,
            duration: const Duration(milliseconds: 500),
            planetColor: const Color(0xFF6F5F5F),
            planetSize: 7,
          ), // Mercury
          OrbitingPlanet(
            radius: 55,
            duration: const Duration(milliseconds: 1000),
            planetColor: const Color(0xFFE7A71F),
            planetSize: 10,
          ), // Venus
          OrbitingPlanet(
            radius: 70,
            duration: const Duration(milliseconds: 1500),
            planetColor: const Color(0xFF63BEE2),
            planetSize: 10,
          ), // Earth
          OrbitingPlanet(
            radius: 85,
            duration: const Duration(milliseconds: 2000),
            planetColor: Colors.red,
            planetSize: 10,
          ), // Mars
          
          // Cinturón de Asteroides (Estático o de baja opacidad)
          _buildAsteroidBelt(radius: 120),

          OrbitingPlanet(
            radius: 130,
            duration: const Duration(milliseconds: 2500),
            planetColor: const Color(0xFFCF9B2B),
            planetSize: 30,
            planetOffset: -15,
          ), // Jupiter
          OrbitingPlanet(
            radius: 160,
            duration: const Duration(milliseconds: 3000),
            planetColor: const Color(0xFFCF7A2B),
            planetSize: 20,
            planetOffset: -10,
            hasRing: true,
          ), // Saturn
          OrbitingPlanet(
            radius: 180,
            duration: const Duration(milliseconds: 3500),
            planetColor: const Color(0xFF10C593),
            planetSize: 15,
            planetOffset: -8,
          ), // Uranus
          OrbitingPlanet(
            radius: 200,
            duration: const Duration(milliseconds: 4000),
            planetColor: const Color(0xFF1470E4),
            planetSize: 15,
            planetOffset: -8,
          ), // Neptune
        ],
      ),
    );
  }

  Widget _buildSun() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final color = Color.lerp(Colors.orange, const Color(0xFFFFEB00), _glowController.value);
        final glowSize = _glowController.value * 20.0;

        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              if (glowSize > 0)
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.7),
                  blurRadius: glowSize,
                  spreadRadius: glowSize / 4,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAsteroidBelt({required double radius}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x35242323),
          width: 25,
        ),
      ),
    );
  }
}

/// Widget interno que maneja su propia animación para evitar saltos al reiniciar el ciclo.
class OrbitingPlanet extends StatefulWidget {
  final double radius;
  final Duration duration;
  final Color planetColor;
  final double planetSize;
  final double planetOffset;
  final bool hasRing;

  const OrbitingPlanet({
    super.key,
    required this.radius,
    required this.duration,
    required this.planetColor,
    required this.planetSize,
    this.planetOffset = -5,
    this.hasRing = false,
  });

  @override
  State<OrbitingPlanet> createState() => _OrbitingPlanetState();
}

class _OrbitingPlanetState extends State<OrbitingPlanet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: -_controller.value * 2 * math.pi, // Rotación fluida e independiente
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Camino de la órbita
              Container(
                width: widget.radius * 2,
                height: widget.radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
              // Planeta
              Positioned(
                top: 0 + widget.planetOffset,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: widget.planetSize,
                      height: widget.planetSize,
                      decoration: BoxDecoration(
                        color: widget.planetColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (widget.hasRing)
                      Transform.rotate(
                        angle: 20 * math.pi / 180,
                        child: Container(
                          width: widget.planetSize * 1.5,
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
