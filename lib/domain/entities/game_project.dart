/// Entidad de dominio que representa un proyecto de juego.
class GameProject {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const GameProject({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameProject &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
