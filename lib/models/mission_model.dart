class MissionModel {
  final String id;
  final String titulo;
  final double recompensaXP;
  final String tipo; //Mental, Física, etc
  DateTime? ultimaConclusao; //Armazena data e hora da conclusao da missão

  //Contrutor
  MissionModel({
    required this.id,
    required this.titulo,
    required this.recompensaXP,
    required this.tipo,
    this.ultimaConclusao,
  });

  //Valida se foi concluído no mesmo dia a missão
  bool get foiConcluidaHoje {
    if (ultimaConclusao == null) return false;
    final agora = DateTime.now();

    return ultimaConclusao!.year == agora.year &&
        ultimaConclusao!.month == agora.month &&
        ultimaConclusao!.day == agora.day;
  }

  int get minutosDesdeAUltimaConclusao {
    if (ultimaConclusao == null) return 999999; //Valor alto para nao realizar
    return DateTime.now().difference(ultimaConclusao!).inMinutes;
  }

  int get horasDesdeAUltimaConclusao {
    if (ultimaConclusao == null) return 999; //Valor alto para nao realizar
    return DateTime.now().difference(ultimaConclusao!).inHours;
  }

  //Converve objeto para Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'recompensaXP': recompensaXP,
      'tipo': tipo,
      'ultimaConclusao': ultimaConclusao?.toIso8601String(),
    };
  }

  //Converte Json para objeto
  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'],
      titulo: json['titulo'],
      recompensaXP: json['recompensaXP'].toDouble(),
      tipo: json['tipo'],
      ultimaConclusao: json['ultimaConclusao'] != null
          ? DateTime.parse(json['ultimaConclusao'])
          : null,
    );
  }
}
