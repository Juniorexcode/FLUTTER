import 'package:flutter/material.dart';

/// Widget genérico de carga diferida para componentes pesados (WebGL, 3D).
///
/// No monta el [child] hasta que [deferDuration] haya pasado después del
/// primer frame. Esto permite que el motor de Flutter y otros contextos
/// WebGL (ej. o3d) terminen de inicializarse antes de agregar carga GPU.
///
/// Mientras espera, muestra un [placeholder] opcional o un indicador de carga.
class DeferredLoader extends StatefulWidget {
  /// Widget pesado que se montará después del delay.
  final Widget child;

  /// Tiempo de espera antes de montar [child].
  final Duration deferDuration;

  /// Widget placeholder mientras se espera.
  final Widget? placeholder;

  const DeferredLoader({
    super.key,
    required this.child,
    this.deferDuration = const Duration(seconds: 4),
    this.placeholder,
  });

  @override
  State<DeferredLoader> createState() => _DeferredLoaderState();
}

class _DeferredLoaderState extends State<DeferredLoader> {
  bool _shouldMount = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.deferDuration, () {
      if (mounted) {
        setState(() => _shouldMount = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldMount) {
      return widget.placeholder ??
          Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          );
    }
    return widget.child;
  }
}
