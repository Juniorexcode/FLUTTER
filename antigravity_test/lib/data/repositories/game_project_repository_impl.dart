import '../../domain/entities/game_project.dart';
import '../../domain/repositories/game_project_repository.dart';
import '../datasources/game_project_local_data_source.dart';

class GameProjectRepositoryImpl implements GameProjectRepository {
  final GameProjectLocalDataSource localDataSource;

  GameProjectRepositoryImpl(this.localDataSource);

  @override
  Future<List<GameProject>> getProjects() async {
    return await localDataSource.getProjects();
  }
}
