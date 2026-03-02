import '../models/game_project_model.dart';
import 'game_project_local_data_source.dart';

/// Implementación local (mock) de [GameProjectLocalDataSource].
class GameProjectLocalDataSourceImpl implements GameProjectLocalDataSource {
  @override
  Future<List<GameProjectModel>> getProjects() async {
    // Simulando retraso de red
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      GameProjectModel(
        id: '1',
        title: 'Cyber Nexus',
        description:
            'Un RPG ciberpunk de mundo abierto con combates dinámicos y narrativa profunda.',
        imageUrl: 'assets/images/project1.png',
      ),
      GameProjectModel(
        id: '2',
        title: 'Aethelgard',
        description:
            'Fantasía épica y exploración en un universo procedural lleno de misterios.',
        imageUrl: 'assets/images/project2.png',
      ),
      GameProjectModel(
        id: '3',
        title: 'Stellar Velocity',
        description:
            'Carreras antigravedad de alta velocidad con modo multijugador competitivo.',
        imageUrl: 'assets/images/project3.png',
      ),
    ];
  }
}
