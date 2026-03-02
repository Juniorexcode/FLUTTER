import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Construye un visor Spline nativo para Flutter Web.
///
/// Utiliza un `HTMLCanvasElement` registrado como Platform View mediante
/// `HtmlElementView`, y carga el runtime de Spline directamente sobre él
/// con un dynamic import de ES Modules. **Sin iframes.**
///
/// El script se inyecta en `document.body` con un delay de 3 segundos
/// para evitar contención de GPU con otros contextos WebGL (ej. o3d).
Widget buildSplineViewer(BuildContext context, String url) {
  return _WebSplineCanvas(splineUrl: url);
}

class _WebSplineCanvas extends StatefulWidget {
  final String splineUrl;

  const _WebSplineCanvas({required this.splineUrl});

  @override
  State<_WebSplineCanvas> createState() => _WebSplineCanvasState();
}

class _WebSplineCanvasState extends State<_WebSplineCanvas> {
  /// ID único generado a partir del hashCode de la URL + timestamp.
  late final String _viewId;
  late final String _canvasId;
  late final String _scriptId;

  @override
  void initState() {
    super.initState();
    final uid = '${widget.splineUrl.hashCode}-${DateTime.now().millisecondsSinceEpoch}';
    _canvasId = 'spline-cv-$uid';
    _viewId = 'spline-view-$uid';
    _scriptId = 'spline-script-$uid';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final canvas = web.HTMLCanvasElement()
        ..id = _canvasId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.display = 'block'
        ..style.outline = 'none';

      _injectLoaderScript();

      return canvas;
    });
  }

  /// Inyecta el script de carga en `document.body` si no existe ya.
  ///
  /// Se usa `setTimeout(3000)` para dar tiempo al motor principal de
  /// Flutter y a o3d de inicializarse primero, evitando que dos
  /// instancias de Three.js compitan por la GPU simultáneamente.
  void _injectLoaderScript() {
    final existing = web.document.getElementById(_scriptId);
    if (existing != null) return;

    final script = web.HTMLScriptElement()
      ..id = _scriptId
      ..type = 'module'
      ..textContent = '''
        setTimeout(async () => {
          try {
            const { Application } = await import(
              'https://unpkg.com/@splinetool/runtime@latest/build/runtime.js'
            );
            const canvas = document.getElementById('$_canvasId');
            if (canvas) {
              const app = new Application(canvas);
              await app.load('${widget.splineUrl}');
            }
          } catch (e) {
            console.error('Spline load error:', e);
          }
        }, 3000);
      ''';

    web.document.body!.append(script);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
