import 'dart:math' as math;
import 'package:flutter/material.dart';

/// AnimatedMoon: Widget de luna interactivo nativo.
/// Estático por defecto, brilla y emite partículas hacia afuera al hacer hover.
class AnimatedMoon extends StatefulWidget {
  final double size;

  const AnimatedMoon({super.key, this.size = 120.0});

  @override
  State<AnimatedMoon> createState() => _AnimatedMoonState();
}

class _AnimatedMoonState extends State<AnimatedMoon> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _particleController;
  bool _isHovered = false;

  final math.Random _random = math.Random(42);
  
  // Datos precalculados para las partículas
  late List<double> _particleAngles;
  late List<double> _particleSpeeds;
  late List<double> _particlePhases;
  late List<double> _particleSizes;

  @override
  void initState() {
    super.initState();
    // Controlador para la expansión de la luna
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Controlador para las partículas en loop
    _particleController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 2000),
    );

    _particleAngles = List.generate(30, (i) => _random.nextDouble() * 2 * math.pi);
    _particleSpeeds = List.generate(30, (i) => 0.5 + _random.nextDouble() * 1.0);
    _particlePhases = List.generate(30, (i) => _random.nextDouble());
    _particleSizes = List.generate(30, (i) => 3.0 + _random.nextDouble() * 4.0);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _hoverController.forward();
      _particleController.repeat();
    } else {
      _hoverController.reverse();
      // Dejamos de emitir partículas; en un caso ideal podríamos dejarlas terminar, 
      // pero detener el controlador limpia la animación de inmediato
      _particleController.stop();
      _particleController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        cursor: SystemMouseCursors.click,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Partículas emitidas (sólo visibles durante el hover)
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                if (!_isHovered) return const SizedBox.shrink();

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: List.generate(30, (i) {
                    final double globalPhase = _particleController.value;
                    // Desfase individual
                    final double phase = (globalPhase + _particlePhases[i]) % 1.0;
                    
                    // Distancia desde el centro (empiezan en el borde de la luna y salen hacia afuera)
                    final double startRadius = widget.size * 0.45;
                    final double maxRadius = widget.size * 1.5;
                    final double currentRadius = startRadius + (maxRadius * phase * _particleSpeeds[i]);
                    
                    // Opacidad: aparece suavemente, brilla, y se desvanece al final
                    final double opacity = math.sin(phase * math.pi);
                    
                    // Posición cartesiana
                    final double x = math.cos(_particleAngles[i]) * currentRadius;
                    final double y = math.sin(_particleAngles[i]) * currentRadius;

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Container(
                          width: _particleSizes[i],
                          height: _particleSizes[i],
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFADD8E6).withValues(alpha: 0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            
            // Luna con expansión de escala animada sobre _hoverController
            AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                final scale = 1.0 + (_hoverController.value * 0.15); // Expansión de 15%
                final glowRadius = 40.0 + (_hoverController.value * 40.0); // Aumenta de 40 a 80
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF0F0F0), Colors.white],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        // Resplandor exterior dinámico
                        BoxShadow(
                          color: const Color(0xFFEBEBEB).withValues(alpha: 0.6),
                          blurRadius: glowRadius,
                          spreadRadius: _hoverController.value * 5.0,
                        ),
                        // Sombra interior
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(-5, -5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildCrater(left: widget.size * 0.18, top: widget.size * 0.25, size: widget.size * 0.18),
                        _buildCrater(left: widget.size * 0.50, top: widget.size * 0.56, size: widget.size * 0.25),
                        _buildCrater(left: widget.size * 0.25, top: widget.size * 0.68, size: widget.size * 0.15),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrater({required double left, required double top, required double size}) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFC8C8C8).withValues(alpha: 0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}

