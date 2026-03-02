import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/button_debouncer.dart';
import '../widgets/animated_saturn.dart';
import '../widgets/animated_moon.dart';
import '../widgets/animated_room_scene.dart';
import '../widgets/floating_space_element.dart';
import '../widgets/draggable_space_element.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late final ButtonDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = ButtonDebouncer();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    return SizedBox(
      height: isMobile ? null : MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background floating elements
          FloatingSpaceElement(
            top: 50,
            right: isMobile ? -20 : MediaQuery.of(context).size.width * 0.05,
            durationSeconds: 20,
            maxOscillation: 15,
            child: const AnimatedSaturn(size: 100),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.contentHorizontalPadding,
              vertical: isMobile ? 120 : 0, 
            ),
            child: Center(
              child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
            ),
          ),
          
          // Foreground interactive elements
          
          // Draggable Moon: Responsive sizing and position
          DraggableSpaceElement(
            initialTop: isMobile ? 60 : MediaQuery.of(context).size.height * 0.05, 
            initialLeft: isMobile ? 20 : MediaQuery.of(context).size.width * 0.01, 
            childSize: Size(isMobile ? 100 : 160, isMobile ? 100 : 160), 
            child: AnimatedMoon(size: isMobile ? 100 : 160),
          ),
          
          // Draggable Boy: Left Center
          DraggableSpaceElement(
            initialTop: isMobile ? 320 : MediaQuery.of(context).size.height * 0.15,
            initialLeft: isMobile ? -30 : MediaQuery.of(context).size.width * 0.35,
            childSize: Size(isMobile ? 320 : 480, (isMobile ? 320 : 480) * 1.5), 
            child: Image.asset(
              'assets/images/boy.png',
              width: isMobile ? 320 : 480,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: _buildTextContent(context, TextAlign.left),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 600,
            child: const AnimatedRoomScene(
              assetPath: 'assets/isometric_rec_room-v1.glb',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextContent(context, TextAlign.center),
        const SizedBox(height: 64),
        SizedBox(
          height: 400,
          child: const AnimatedRoomScene(
            assetPath: 'assets/isometric_rec_room-v1.glb',
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context, TextAlign align) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: align == TextAlign.left ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'Forjando\nMundos Estelares',
          textAlign: align,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                height: 1.1,
              ),
        ),
        const SizedBox(height: 24),
        Text(
          'Desarrollo de videojuegos de próxima generación.\nSumérgete en lo extraordinario.',
          textAlign: align,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () {
            _debouncer.run(() {
              // Acción de explorar proyectos
            });
          },
          child: const Text('Explorar Proyectos', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
