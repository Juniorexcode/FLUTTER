import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_dimensions.dart';
import 'animated_hamburger_button.dart';
import 'app_logo.dart';
import 'glass_container.dart';
import '../../domain/models/nav_item.dart';
import 'nav_links_row.dart';

/// Scroll threshold in pixels over which the nav bar fully materializes.
const double _kScrollThreshold = 150.0;

/// Animated navigation bar that transitions between two states:
///
/// - **Top (scroll = 0):** Fully transparent, nav links centered.
/// - **Scrolled (scroll ≥ threshold):** Glass container with logo + right-aligned links.
class CustomNavBar extends StatelessWidget {
  final ScrollController scrollController;

  /// Normalized scroll progress from 0.0 (top) to 1.0 (scrolled).
  final double scrollOffset;

  final bool isMenuOpen;
  final VoidCallback onToggleMenu;

  const CustomNavBar({
    super.key,
    required this.scrollController,
    required this.scrollOffset,
    this.isMenuOpen = false,
    required this.onToggleMenu,
  });

  /// Navigation destinations — centralized, data-driven.
  static const List<NavItem> navItems = [
    NavItem(title: 'Inicio', scrollOffset: 0),
    NavItem(title: 'Proyectos', scrollOffset: 800),
    NavItem(title: 'Nosotros', scrollOffset: 1600),
    NavItem(title: 'Contacto', scrollOffset: 2400),
  ];

  double get _progress => (scrollOffset / _kScrollThreshold).clamp(0.0, 1.0);

  void _scrollTo(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    final double scrollTarget = Curves.easeInOut.transform(_progress);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Stack(
        children: [
          // Capa Base: El Contenedor de Cristal (Glassmorphism)
          // Usamos Visibility para ocultarlo instantáneamente sin desvanecimientos fantasma
          Positioned.fill(
            child: IgnorePointer(
              child: Visibility(
                visible: !(isMobile && isMenuOpen),
                child: GlassContainer(
                  progress: scrollTarget,
                  borderRadius: AppDimensions.navBarBorderRadius,
                  padding: EdgeInsets.zero,
                  child: const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          
          // Capa Frontal: Contenido (Logo y NavLinks/Botón)
          // Separado en su propia capa para que sus animaciones jamás se rompan
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.navBarHorizontalPadding,
              vertical: AppDimensions.navBarVerticalPadding,
            ),
            constraints: const BoxConstraints(minHeight: 56),
            child: isMobile
                ? _buildMobileLayout(context, scrollTarget)
                : _buildDesktopLayout(context, scrollTarget),
          ),
        ],
      ),
    );
  }

  /// Desktop: Logo always visible; links move from center → right.
  Widget _buildDesktopLayout(BuildContext context, double t) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Logo — always visible, subtle slide
        Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(-20 * (1 - t), 0),
            child: const AppLogo(),
          ),
        ),
        // Nav links — animate from center to right
        Align(
          alignment: Alignment.lerp(
            Alignment.center,
            Alignment.centerRight,
            t,
          )!,
          child: NavLinksRow(
            items: navItems,
            onNavigate: _scrollTo,
          ),
        ),
      ],
    );
  }

  /// Mobile: Logo always visible, hamburger menu stays.
  Widget _buildMobileLayout(BuildContext context, double t) {
    // Calculamos el ancho de la pantalla para el desplazamiento
    final screenWidth = MediaQuery.of(context).size.width;
    // Si el menú está abierto, deslizamos el logo a la derecha un poco (15%) para que no 
    // quede cortado por la barrera del glass blur y se aprecie centrado en el panel.
    final double logoSlideOffset = isMenuOpen ? (screenWidth * 0.15) : -20 * (1 - t);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo — always visible con transición fluida
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(logoSlideOffset, 0, 0),
          child: const AppLogo(),
        ),
        // Menu button
        Hero(
          tag: 'hamburger_menu_btn',
          child: Material(
            color: Colors.transparent,
            child: AnimatedHamburgerButton(
              isOpened: isMenuOpen,
              onTap: onToggleMenu,
            ),
          ),
        ),
      ],
    );
  }
}
