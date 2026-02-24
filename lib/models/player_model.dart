class PlayerModel {
  int level;
  double xp;
  int fisico;
  int mental;

  PlayerModel({
    this.level = 1,
    this.xp = 0.0,
    this.fisico = 0,
    this.mental = 0,
  });

  // Converte JSON (Mapa) para Objeto Dart
  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0.0,
      fisico: json['fisico'] ?? 0,
      mental: json['mental'] ?? 0,
    );
  }

  // Converte Objeto Dart para JSON (Mapa)
  Map<String, dynamic> toJson() {
    return {'level': level, 'xp': xp, 'fisico': fisico, 'mental': mental};
  }
}
