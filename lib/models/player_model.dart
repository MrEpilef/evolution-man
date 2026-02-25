import 'mission_model.dart';

class PlayerModel {
  int level;
  double xp;
  int fisico;
  int mental;
  List<MissionModel> missoes;

  PlayerModel({
    required this.level,
    required this.xp,
    required this.fisico,
    required this.mental,
    required this.missoes,
  });

  // Converte JSON (Mapa) para Objeto Dart
  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    // Garantimos que a lista de missões nunca seja nula
    var list = json['missoes'] as List? ?? [];
    List<MissionModel> missionList = list.map((i) => MissionModel.fromJson(i)).toList();

    return PlayerModel(
      level: json['level'] ?? 1,
      xp: (json['xp'] ?? 0.0).toDouble(),
      fisico: json['fisico'] ?? 0,
      mental: json['mental'] ?? 0,
      missoes: missionList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'xp': xp,
      'fisico': fisico,
      'mental': mental,
      'missoes': missoes.map((m) => m.toJson()).toList(),
    };
  }
}
