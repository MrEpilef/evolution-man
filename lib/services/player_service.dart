import '../models/player_model.dart';

class PlayerService{
  /// Processa o ganho de XP e verifica evolução de nível.
  /// Aplica a regra de negócio central do sistema.
  PlayerModel processarGanhoXP(PlayerModel player, double quantidade){
    // Validação de segurança: XP não pode ser negativo
    if (quantidade <= 0) return player;

    double novoXp = player.xp + (quantidade / 100);
    int novoLevel = player.level;

    // Lógica de Level Up (Pode ser complexa no futuro, ex: curva de XP)
    while (novoXp >= 1.0){
      novoXp -= 1.0;
      novoLevel++;

    }
    // Retorna uma nova instância ou atualiza a atual 
    // (Bons princípios: imutabilidade ajuda a evitar bugs de estado)

    player.xp = novoXp;
    player.level = novoLevel;

    return player;
  }
}