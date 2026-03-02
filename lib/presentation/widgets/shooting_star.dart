import 'dart:math' as math;

/// Entidad ShootingStar que representa una estrella fugaz
class ShootingStar {
  final double startX;
  final double startY;
  final double length;
  final double speed;
  final double delay;
  final double angle;
  final double width;

  ShootingStar()
      : startX = math.Random().nextDouble() * 2.0 - 0.5, 
        startY = math.Random().nextDouble() * 1.0 - 0.3, 
        length = math.Random().nextDouble() * 100 + 30, 
        speed = math.Random().nextDouble() * 2.0 + 0.5, 
        delay = math.Random().nextDouble() * 1.0, 
        angle = (math.Random().nextDouble() * 40 + 20) * math.pi / 180, 
        width = math.Random().nextDouble() * 1.5 + 0.8; 
}
