import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// DraggableSpaceElement: Un componente flotante genérico que puede ser arrastrado.
/// Tiene animación "idle" (flotación natural), inercia al soltarlo y rebote 
/// suave al chocar con los bordes de la pantalla, simulando gravedad cero.
class DraggableSpaceElement extends StatefulWidget {
  final Widget child;
  final double initialLeft;
  final double initialTop;
  final Size childSize;
  
  const DraggableSpaceElement({
    super.key,
    required this.child,
    required this.initialLeft,
    required this.initialTop,
    required this.childSize,
  });

  @override
  State<DraggableSpaceElement> createState() => _DraggableSpaceElementState();
}

class _DraggableSpaceElementState extends State<DraggableSpaceElement> with TickerProviderStateMixin {
  // Posición actual
  late double _left;
  late double _top;
  
  // Controlador de inercia y rebote (física)
  late AnimationController _physicsController;
  
  // Controlador de flotación natural (idle)
  late AnimationController _idleController;

  // Variables para la simulación
  double _velocityX = 0;
  double _velocityY = 0;
  DateTime _lastTick = DateTime.now();

  @override
  void initState() {
    super.initState();
    _left = widget.initialLeft;
    _top = widget.initialTop;

    // Animador de inercia, unbounded para permitir físicas libres
    _physicsController = AnimationController.unbounded(vsync: this);
    _physicsController.addListener(_onPhysicsUpdate);

    // Animador Idle (Levitación)
    _idleController = AnimationController(
       vsync: this, 
       duration: const Duration(seconds: 12)
    )..repeat();
  }

  @override
  void dispose() {
    _physicsController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  // --- INTERACCIÓN Y FÍSICA ---

  void _onPanStart(DragStartDetails details) {
    // Si lo agarramos, detenemos cualquier inercia y la levitación
    _physicsController.stop();
    _idleController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _left += details.delta.dx;
      _top += details.delta.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Al soltarlo, le aplicamos la velocidad terminal capturada por el gesto
    _velocityX = details.velocity.pixelsPerSecond.dx;
    _velocityY = details.velocity.pixelsPerSecond.dy;

    // Si la velocidad es muy baja, reactivamos flotación simple
    if (_velocityX.abs() < 50 && _velocityY.abs() < 50) {
       _idleController.repeat();
    } else {
       _runPhysicsSimulation();
    }
  }

  void _runPhysicsSimulation() {
    _lastTick = DateTime.now();
    // Usamos una simulación base genérica porque nós calcularemos el desplazamiento X,Y 
    // manualmente en el listener para poder rebotar independientemente por eje.
    _physicsController.animateWith(
      FrictionSimulation(
        0.5, // Resistencia (0.5 es baja fricción = espacio resbaladizo)
        0, 
        math.sqrt(_velocityX * _velocityX + _velocityY * _velocityY), // Velocidad total inicial
      ),
    ).then((_) {
      // Cuando termina la inercia (velocidad casi cero), volvemos a flotar
      _idleController.repeat();
    });
  }

  void _onPhysicsUpdate() {
    final now = DateTime.now();
    final deltaT = now.difference(_lastTick).inMicroseconds / 1000000.0;
    _lastTick = now;

    if (deltaT <= 0) return;

    // Aplicar fricción manual por frame para decaer la velocidad gradualmente
    const friction = 1.2; // factor de fricción manual
    _velocityX -= _velocityX * friction * deltaT;
    _velocityY -= _velocityY * friction * deltaT;

    setState(() {
      _left += _velocityX * deltaT;
      _top += _velocityY * deltaT;

      // Restricciones de bordes y REBOTE
      final size = MediaQuery.of(context).size;

      bool bounced = false;

      // Colisión Derecha
      if (_left + widget.childSize.width > size.width) {
        _left = size.width - widget.childSize.width;
        _velocityX = -_velocityX * 0.8; // Invierte dir, pierde 20% energía
        bounced = true;
      }
      // Colisión Izquierda
      else if (_left < 0) {
        _left = 0;
        _velocityX = -_velocityX * 0.8;
        bounced = true;
      }

      // Colisión Abajo
      if (_top + widget.childSize.height > size.height) {
        _top = size.height - widget.childSize.height;
        _velocityY = -_velocityY * 0.8;
        bounced = true;
      }
      // Colisión Arriba
      else if (_top < 0) {
        _top = 0;
        _velocityY = -_velocityY * 0.8;
        bounced = true;
      }

      // Si la velocidad se vuelve muy ínfima, detenemos la física para no gastar batería
      if (!bounced && _velocityX.abs() < 10 && _velocityY.abs() < 10) {
        _physicsController.stop();
        _idleController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: AnimatedBuilder(
            animation: _idleController,
            builder: (context, child) {
              // Idle oscillation si el physics controler no está corriendo
              double idleDy = 0;
              double idleAngle = 0;
              
              if (!_physicsController.isAnimating) {
                idleDy = math.sin(_idleController.value * 2 * math.pi) * 15.0; // Oscila 15px
                idleAngle = math.sin(_idleController.value * 2 * math.pi) * 0.03; // Rotación leve
              }

              return Transform.translate(
                offset: Offset(0, idleDy),
                child: Transform.rotate(
                  angle: idleAngle,
                  child: widget.child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
