import 'package:flutter/material.dart';

/// Entidad que representa un proyecto del portafolio.
class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Color> gradientColors;
  final String? projectUrl;
  final String? githubUrl;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gradientColors,
    this.projectUrl,
    this.githubUrl,
  });
}
