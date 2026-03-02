import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton3D extends StatefulWidget {
  final String svgString;
  final double cardHover;
  final double delayRatio;
  final Color baseColor;

  const SocialButton3D({
    super.key,
    required this.svgString,
    required this.cardHover,
    required this.delayRatio,
    required this.baseColor,
  });

  @override
  State<SocialButton3D> createState() => _SocialButton3DState();
}

class _SocialButton3DState extends State<SocialButton3D> {
  bool _isHovered = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    double popHover = 0.0;
    if (widget.cardHover > widget.delayRatio) {
      popHover = ((widget.cardHover - widget.delayRatio) / (1.0 - widget.delayRatio)).clamp(0.0, 1.0);
    }

    double baseZ = popHover * 40.0;
    double scale = 1.0;
    Color bgColor = Colors.white;
    Color iconColor = widget.baseColor;

    if (_isActive) {
      scale = 1.05;
      baseZ = 20.0;
      bgColor = const Color(0xFF8800FF);
      iconColor = Colors.black;
    } else if (_isHovered) {
      scale = 1.1;
      baseZ = 30.0;
      bgColor = Colors.black;
      iconColor = Colors.white;
    }

    // NOTA: El Z base (cardHover * 35.0) ahora es manejado por el _buildLayer del padre
    // para arreglar los hit-test bajo perspectiva. Solo aplicamos la elevación local del botón.
    final transformMatrix = Matrix4.translationValues(0.0, 0.0, baseZ)
      ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0));

    // Desacoplamos el Transform explícito del AnimatedContainer implícito 
    // para evitar que el 'hit test box' intente animarse asíncronamente mientras el cursor se mueve.
    return Transform(
      alignment: Alignment.center,
      transform: transformMatrix,
      child: MouseRegion( 
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _isActive = false;
        }),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isActive = true),
          onTapUp: (_) => setState(() => _isActive = false),
          onTapCancel: () => setState(() => _isActive = false),
          behavior: HitTestBehavior.opaque, 
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              boxShadow: [
                if (_isHovered && !_isActive)
                  BoxShadow(
                    color: const Color.fromRGBO(34, 5, 71, 1.0).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(-5, 10),
                  )
                else if (!_isActive && widget.cardHover > 0)
                  BoxShadow(
                    color: const Color.fromRGBO(34, 5, 71, 1.0).withValues(alpha: 0.2),
                    blurRadius: 5,
                    offset: const Offset(-3, 10),
                  )
                else
                  BoxShadow(
                    color: const Color.fromRGBO(28, 5, 71, 1.0).withValues(alpha: 0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 5),
                  )
              ]
            ),
            child: Center(
              child: SvgPicture.string(
                widget.svgString,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
