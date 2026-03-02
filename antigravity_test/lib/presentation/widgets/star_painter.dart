import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'star.dart';
import 'shooting_star.dart';

/// Painter encargado EXCLUSIVAMENTE de renderizar la galaxia.
/// Sigue el principio de Responsabilidad Única (SRP) de SOLID.
class StarPainter extends CustomPainter {
  final List<Star> stars;
  final List<ShootingStar> shootingStars;
  final double animationValue;
  final double shootingValue;

  StarPainter(this.stars, this.shootingStars, this.animationValue, this.shootingValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Dibujar estrellas base
    for (var star in stars) {
      double dy = star.y * size.height + (animationValue * size.height * star.speed);
      double dx = star.x * size.width;

      double blinkSpeed = 10.0 + (star.speed * 50); 
      double opacity = (math.sin(animationValue * math.pi * 2 * blinkSpeed + star.blinkOffset) + 1) / 2;

      // Glow 
      if (star.size > 1.8) {
        canvas.drawCircle(
          Offset(dx, dy), 
          star.size * 2.5, 
          paint..color = Colors.white.withValues(alpha: opacity * 0.15)
        );
      }
      
      canvas.drawCircle(
        Offset(dx, dy), 
        star.size, 
        paint..color = Colors.white.withValues(alpha: opacity * 0.7 + 0.3)
      );
    }

    // Dibujar estrellas fugaces
    for (var sStar in shootingStars) {
      double progress = (shootingValue - sStar.delay) % 1.0;
      if (progress < 0) progress += 1.0;
      
      double lifeSpan = 0.15; // 15% del tiempo total dedicado al rastro
      
      if (progress > 0 && progress < lifeSpan) {
        double normalizedProgress = progress / lifeSpan; // Escala 0 a 1 local
        
        double currentX = sStar.startX * size.width + math.cos(sStar.angle) * normalizedProgress * size.width * sStar.speed;
        double currentY = sStar.startY * size.height + math.sin(sStar.angle) * normalizedProgress * size.width * sStar.speed;
        
        Offset p1 = Offset(currentX, currentY); // Cabeza brillante
        Offset p2 = Offset(currentX - math.cos(sStar.angle) * sStar.length, currentY - math.sin(sStar.angle) * sStar.length); // Cola
        
        var trailPaint = Paint()
          ..strokeWidth = sStar.width
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(
            p1, 
            p2, 
            [
              Colors.white.withValues(alpha: 1.0 - normalizedProgress), 
              Colors.white.withValues(alpha: 0.0), 
            ],
          );

        canvas.drawLine(p1, p2, trailPaint);
        // Destello en la cabeza
        canvas.drawCircle(p1, sStar.width * 1.5, Paint()..color = Colors.white.withValues(alpha: 1.0 - normalizedProgress));
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        shootingValue != oldDelegate.shootingValue;
  }
}
