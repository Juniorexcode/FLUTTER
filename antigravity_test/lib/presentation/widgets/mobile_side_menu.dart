import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/nav_item.dart';

/// Un menú lateral móvil "Dreamy" con Glassmorphism.
class MobileSideMenu extends StatelessWidget {
  final List<NavItem> navItems;
  final ValueChanged<double> onNavigate;

  const MobileSideMenu({
    super.key,
    required this.navItems,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Toma el 80% del ancho de la pantalla para dejar ver el contexto de fondo.
    final width = MediaQuery.of(context).size.width * 0.8;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(35)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.backgroundDark.withValues(alpha: 0.8),
                      AppTheme.primary.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  border: Border(
                    left: BorderSide(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 100), // Espacio para el top bar transparente (donde está el botón hamburger original)
                      
                      // Opciones de Navegación del Nav Bar
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: navItems.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final item = navItems[index];
                            return _MenuLinkButton(
                              item: item,
                              onTap: () {
                                onNavigate(item.scrollOffset);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Elemento clickeable invidiual para las opciones del Menu con estilo Glassmorphism "Dreamy"
class _MenuLinkButton extends StatelessWidget {
  final NavItem item;
  final VoidCallback onTap;

  const _MenuLinkButton({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: AppTheme.secondary.withValues(alpha: 0.3),
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.secondary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
