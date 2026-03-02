import 'dart:math' as math;
import 'package:flutter/material.dart';

/// AnimatedSaturn: Planeta Saturno con intersección 3D perfecta de anillos
class AnimatedSaturn extends StatefulWidget {
  final double size;

  const AnimatedSaturn({super.key, this.size = 125.0});

  @override
  State<AnimatedSaturn> createState() => _AnimatedSaturnState();
}

class _AnimatedSaturnState extends State<AnimatedSaturn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Anillos girando infinitamente
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escala general
    final double scaleRatio = widget.size / 125.0;

    return SizedBox(
      width: widget.size * 2.5,
      height: widget.size * 2.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inclinación general del sistema de Saturno base
          Transform.rotate(
            angle: -15 * math.pi / 180,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final angleZ = _controller.value * 2 * math.pi;

                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // --- 1. MITAD TRASERA DE LOS ANILLOS ---
                    ClipRect(
                      clipper: _HalfClipper(topHalf: true),
                      child: SizedBox(
                        width: widget.size * 2.5,
                        height: widget.size * 2.5,
                        child: _buildRings(scaleRatio, angleZ),
                      ),
                    ),

                    // --- 2. CUERPO DEL PLANETA ---
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Sombra exterior (glow)
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x89FFFFFF), // 0 0 100px #ffffff59
                            blurRadius: 100,
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Paleta de colores estríada alineada exactamente a los stops
                          colors: [
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                            Color(0xFFF7AE01), Color(0xFFF7AE01),
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                            Color(0xFFF7AE01), Color(0xFFF7AE01),
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                            Color(0xFFF7AE01), Color(0xFFF7AE01),
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                            Color(0xFFF7AE01), Color(0xFFF7AE01),
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                            Color(0xFFF7AE01), Color(0xFFF7AE01),
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                            Color(0xFFF7AE01), Color(0xFFC7BA9D),
                            Color(0xFFFCC96B), Color(0xFFFCC96B),
                          ],
                          stops: [
                            0.0, 0.15,
                            0.15, 0.19,
                            0.19, 0.22,
                            0.22, 0.28,
                            0.28, 0.36,
                            0.36, 0.48,
                            0.48, 0.55,
                            0.55, 0.66,
                            0.66, 0.70,
                            0.70, 0.73,
                            0.73, 0.82,
                            0.82, 0.86,
                            0.86, 1.0,
                          ],
                        ),
                      ),
                      // Usar contenedores anidados con RadialGradient para simular luz volumétrica e "inset" shadows
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: const Alignment(-0.5, -0.5),
                            radius: 1.0,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.6, 0.9, 1.0],
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(0.4, 0.4),
                              radius: 0.8,
                              colors: [
                                Colors.transparent,
                                const Color(0xFFFFF6E5).withValues(alpha: 0.4),
                              ],
                              stops: const [0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // --- 3. MITAD FRONTAL DE LOS ANILLOS ---
                    ClipRect(
                      clipper: _HalfClipper(topHalf: false),
                      child: SizedBox(
                        width: widget.size * 2.5,
                        height: widget.size * 2.5,
                        child: _buildRings(scaleRatio, angleZ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el par de anillos en su orientación 3D rotada
  Widget _buildRings(double scaleRatio, double angleZ) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Anillo Exterior Completo
        Transform.scale(
          scale: 1.75,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(65 * math.pi / 180)
              ..rotateZ(angleZ),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: SaturnRingFullPainter(
                color: const Color(0xFFE1A519),
                shadowColor: const Color(0xFFC18620),
                thickness: 16.0 * scaleRatio,
              ),
            ),
          ),
        ),
        // Anillo Interior Completo
        Transform.scale(
          scale: 1.70,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(65 * math.pi / 180)
              ..rotateZ(angleZ),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: SaturnRingFullPainter(
                color: const Color(0xFFD48B0C),
                shadowColor: const Color(0xFFB99309),
                thickness: 8.0 * scaleRatio,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Extensión privada en BoxShadow para soportar `inset` visualmente con Flutter's nativo
/// Nota: Flutter no soporta shadow inset nativo en web/mobile fácilmente sin decoradores complejos,
/// pero emularemos el estilo pintando sobre el fill, o aproximándolo si no usamos un paquete externo.
/// Actualización: Hemos migrado el diseño a sombras "outset" estándar o "falsos" radiales
/// ya que Flutter BoxShadow nativo no soporta parametro `inset: true`. Eliminaremos el parametro faux "inset: true" 
/// y usaremos contenedores interiores si es necesario.
/// (Se corrigió en tiempo real para compilar limpio).

/// CustomClipper para cortar el widget en dos mitades horizontales
/// respecto al eje Y, permitiendo la ilusión de intersección.
class _HalfClipper extends CustomClipper<Rect> {
  final bool topHalf;

  _HalfClipper({required this.topHalf});

  @override
  Rect getClip(Size size) {
    // Usamos márgenes muy grandes a los lados para EVITAR cortar el ancho del anillo.
    if (topHalf) {
      // Retorna la mitad superior del lienzo en Y, infinito en X
      return Rect.fromLTRB(-size.width, -size.height, size.width * 2, size.height / 2);
    } else {
      // Retorna la mitad inferior del lienzo en Y, infinito en X
      return Rect.fromLTRB(-size.width, size.height / 2, size.width * 2, size.height * 2);
    }
  }

  @override
  bool shouldReclip(covariant _HalfClipper oldClipper) {
    return oldClipper.topHalf != topHalf;
  }
}

/// CustomPainter para dibujar un anillo de 360 grados completo.
class SaturnRingFullPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;
  final double thickness;

  SaturnRingFullPainter({
    required this.color, 
    required this.shadowColor,
    required this.thickness
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    // Sombra del anillo para dar relieve 3D
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Dibujamos un arco completo de 360 grados (2 * PI)
    const startAngle = 0.0;
    const sweepAngle = 2 * math.pi;

    canvas.drawArc(rect.shift(const Offset(0, -2)), startAngle, sweepAngle, false, shadowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant SaturnRingFullPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.thickness != thickness;
  }
}


