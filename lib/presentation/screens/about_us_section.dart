import 'package:flutter/material.dart';
import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/solar_system_loader.dart';

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.sectionVerticalPadding,
        horizontal: AppDimensions.contentHorizontalPadding,
      ),
      child: Column(
        children: [
          Text('Acerca de Nosotros', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 48),
          _buildContent(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile) {
    final textBlock = GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Más que código',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'En Onirisoft, no solo hacemos juegos; construimos experiencias. '
            'Integramos tecnología de punta como WebGL y motores de renderizado '
            'avanzado para llevar la inmersión al siguiente nivel.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );

    final sceneBlock = Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary.withValues(alpha: 0.2),
                AppTheme.secondary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: SolarSystemLoader(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          textBlock,
          const SizedBox(height: 48),
          sceneBlock,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: textBlock),
        const SizedBox(width: 48),
        Expanded(child: sceneBlock),
      ],
    );
  }
}
