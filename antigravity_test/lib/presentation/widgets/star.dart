import 'dart:math' as math;

/// Entidad Star que representa una estrella simple en la galaxia
class Star {
  final double x;
  final double y;
  final double size;
  final double blinkOffset;
  final double speed;

  Star()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble() * 1.2 - 0.2, // Cubre la pequeña deriva
        size = math.Random().nextDouble() * 2.0 + 0.5, 
        blinkOffset = math.Random().nextDouble() * math.pi * 2,
        speed = math.Random().nextDouble() * 0.1 + 0.02; 
}
