import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

/// Renders a GLB 3D model using the **o3d** engine.
///
/// Wrapped in [IgnorePointer] so scroll events pass through to the
/// page instead of being captured by the 3D canvas (no zoom-on-scroll).
class GlbSceneViewer extends StatefulWidget {
  /// Path to the bundled GLB asset (e.g. `'assets/model.glb'`).
  final String assetPath;

  /// Whether the model rotates automatically.
  final bool autoRotate;

  /// Whether the user can orbit/zoom via drag & scroll.
  /// Defaults to **false** to prevent scroll-zoom hijacking the page.
  final bool cameraControls;

  /// Background colour behind the 3D canvas.
  final Color backgroundColor;

  const GlbSceneViewer({
    super.key,
    required this.assetPath,
    this.autoRotate = true,
    this.cameraControls = true,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<GlbSceneViewer> createState() => _GlbSceneViewerState();
}

class _GlbSceneViewerState extends State<GlbSceneViewer> {
  late final O3DController _controller;

  @override
  void initState() {
    super.initState();
    _controller = O3DController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: O3D.asset(
        src: widget.assetPath,
        controller: _controller,
        autoPlay: true,
        
        // --- SIN ROTACIÓN AUTOMÁTICA ---
        // solo debe flotar (manejado por AnimatedRoomScene).
        autoRotate: false,
        
        // --- LÍMITES DE CÁMARA (EJE Y ÚNICAMENTE) ---
        // cameraOrbit define la pose inicial: 
        // Empezamos con 155 grados para dar el look isométrico de frente,
        // 75 grados verticales, y 90% de radio para alejar el zoom y que se vea completo.
        relatedJs: '''
          {
            const mv=document.querySelector('model-viewer'); 
            if (mv) {
              mv.cameraOrbit='45deg 75deg 90%'; 
              mv.setAttribute('interpolation-decay', '200');
              mv.setAttribute('shadow-intensity', '2');
              mv.setAttribute('shadow-softness', '1.5');
              mv.setAttribute('exposure', '0.9');
              mv.setAttribute('tone-mapping', 'aces');
              
              // Efecto de Pantalla Encendida (Glow) dinámico al cargar el modelo
              mv.addEventListener('load', () => {
                const materials = mv.model.materials;
                if (!materials) return;
                materials.forEach(mat => {
                  const name = mat.name.toLowerCase();
                  if (name.includes('screen') || name.includes('tv') || name.includes('monitor') || name.includes('display')) {
                     const pbr = mat.pbrMetallicRoughness;
                     if (pbr && pbr.baseColorTexture && pbr.baseColorTexture.texture && mat.emissiveTexture) {
                        mat.emissiveTexture.setTexture(pbr.baseColorTexture.texture);
                        mat.setEmissiveFactor([1.2, 1.2, 1.2]); 
                     } else {
                        mat.setEmissiveFactor([0.5, 0.5, 0.5]); 
                     }
                  }
                });
              });
            }
          }
        ''',
        minCameraOrbit: '15deg 60deg auto', // Limite izquierdo (Y) y superior (X)
        maxCameraOrbit: '75deg 90deg auto', // Limite derecho (Y) e inferior (X)
        
        // --- SCROLL PROTECTOR ---
        // Puede rotar el objeto manualmente, pero "disableZoom" 
        // desvincula el scroll wheel del canvas, permitiendo bajar en la página web.
        cameraControls: widget.cameraControls,
        disableZoom: true,
      ),
    );
  }
}
