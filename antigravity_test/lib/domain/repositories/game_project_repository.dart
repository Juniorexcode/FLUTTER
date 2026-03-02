import '../entities/game_project.dart';

abstract class GameProjectRepository {
  Future<List<GameProject>> getProjects();
}
