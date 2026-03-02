import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';
import 'social_icon.dart';

/// AppFooter: Componente que se renderiza al final del Landing Page
/// con datos dummy y enlaces generales. Estilo adaptativo y minimalista "Dreamy".
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.contentHorizontalPadding,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildBrandInfo()),
            Expanded(flex: 1, child: _buildLinksSection('Enlaces Rápidos', ['Inicio', 'Proyectos', 'Nosotros', 'Contacto'])),
            Expanded(flex: 1, child: _buildLinksSection('Legal', ['Términos del servicio', 'Política de privacidad', 'Aviso legal'])),
            Expanded(flex: 1, child: _buildSocialLinks()),
          ],
        ),
        const SizedBox(height: 60),
        Divider(color: Colors.white.withValues(alpha: 0.1)),
        const SizedBox(height: 24),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBrandInfo(isMobile: true),
        const SizedBox(height: 40),
        _buildLinksSection('Enlaces Rápidos', ['Inicio', 'Proyectos', 'Nosotros', 'Contacto'], isMobile: true),
        const SizedBox(height: 40),
        _buildLinksSection('Legal', ['Términos del servicio', 'Política de privacidad', 'Aviso legal'], isMobile: true),
        const SizedBox(height: 40),
        _buildSocialLinks(isMobile: true),
        const SizedBox(height: 40),
        Divider(color: Colors.white.withValues(alpha: 0.1)),
        const SizedBox(height: 24),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildBrandInfo({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_awesome, color: AppTheme.secondary, size: 28),
            SizedBox(width: 10),
            Text(
              'Onirisoft',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Forjando el futuro digital con elegancia y rendimiento estructural.\nCreamos experiencias sin fronteras.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildLinksSection(String title, List<String> links, {bool isMobile = false}) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () {}, // Dummy interaction
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                  ),
                  child: Text(link),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSocialLinks({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const Text(
          'Comunidad',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SocialIcon(icon: Icons.language), 
            SizedBox(width: 16),
            SocialIcon(icon: Icons.alternate_email),
            SizedBox(width: 16),
            SocialIcon(icon: Icons.share),
          ],
        ),
      ],
    );
  }

  Widget _buildCopyright() {
    return const Text(
      '© 2026 Onirisoft. Todos los derechos reservados. Diseñado con fluidez.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 13,
      ),
    );
  }
}
