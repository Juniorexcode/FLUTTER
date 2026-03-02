import '../entities/game_project.dart';
import '../repositories/game_project_repository.dart';

class GetGameProjects {
  final GameProjectRepository repository;

  GetGameProjects(this.repository);

  Future<List<GameProject>> call() async {
    return await repository.getProjects();
  }
}
