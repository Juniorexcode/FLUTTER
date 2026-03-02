import '../../domain/entities/game_project.dart';

class GameProjectModel extends GameProject {
  const GameProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
  });

  factory GameProjectModel.fromJson(Map<String, dynamic> json) {
    return GameProjectModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
