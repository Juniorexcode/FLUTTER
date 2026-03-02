import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';

import '../../domain/entities/project_entity.dart';
import '../widgets/project_card_3d.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  // --- MOCK DATA ---
  static const List<ProjectEntity> _mockProjects = [
    ProjectEntity(
      id: '1',
      title: 'UIVERSE (3D UI)',
      description: 'Create, share, and use beautiful custom elements made with CSS and Flutter.',
      imageUrl: 'https://plus.unsplash.com/premium_photo-1681426687411-21986b0626a8?q=80&w=600&auto=format&fit=crop', // Abstract code image
      gradientColors: [Color(0xFFfc466b), Color(0xFF3f5efb)],
    ),
    ProjectEntity(
      id: '2',
      title: 'NEBULA DASHBOARD',
      description: 'A stellar analytical dashboard with glassmorphism components and realtime data.',
      imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=600&auto=format&fit=crop', // Imagen de ejemplo espacial
      gradientColors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
    ),
    ProjectEntity(
      id: '3',
      title: 'E-COMMERCE APP',
      description: 'Modern shopping experience with stunning animations and seamless checkout.',
      imageUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?q=80&w=600&auto=format&fit=crop', // Imagen de tienda
      gradientColors: [Color(0xFFf12711), Color(0xFFf5af19)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.sectionVerticalPadding,
        horizontal: AppDimensions.contentHorizontalPadding,
      ),
      child: Column(
        children: [
          Text('Nuestros Proyectos', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 48),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: _mockProjects.map((project) => ProjectCard3D(project: project)).toList(),
          )
        ],
      ),
    );
  }
}
