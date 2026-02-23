import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../services/player_service.dart';

class PlayerController extends ChangeNotifier {
  final PlayerService _service = PlayerService();
  
  // Iniciamos com um modelo padrão enquanto o arquivo não é lido
  PlayerModel _player = PlayerModel(level: 1, xp: 0.0, fisico: 0, mental: 0);

  // Getter para a View acessar os dados
  PlayerModel get player => _player;

  // Construtor: Chama a inicialização assim que o Controller é criado
  PlayerController() {
    _init();
  }

  // Carrega os dados salvos do JSON
  Future<void> _init() async {
    _player = await _service.loadPlayer();
    notifyListeners(); // Avisa a View que os dados chegaram
  }

  // Função principal para processar novo XP
  void concluirMissao(double ganhoXp, {String? tipo}) {
    _player.xp += (ganhoXp / 100); // Ex: 20 XP vira 0.2

    // Lógica de Atributos (Back-End)
    if (tipo == 'fisico') _player.fisico += 1;
    if (tipo == 'mental') _player.mental += 1;

    // Lógica de Level Up
    if (_player.xp >= 1.0) {
      _player.level += 1;
      _player.xp = 0.0;
    }

    // A MÁGICA ACONTECE AQUI:
    // Após mudar os dados na memória, mandamos o serviço gravar no JSON
    _service.savePlayer(_player);
    
    notifyListeners(); // Atualiza a interface
  }
}