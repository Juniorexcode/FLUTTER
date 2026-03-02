import '../models/game_project_model.dart';

/// Contrato para la fuente de datos local de proyectos de juego.
abstract class GameProjectLocalDataSource {
  Future<List<GameProjectModel>> getProjects();
}
