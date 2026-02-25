import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/mission_model.dart';
import '../services/player_service.dart';

class PlayerController extends ChangeNotifier {
  final PlayerService _service = PlayerService();
  
  // Inicializamos com uma lista vazia para evitar erros de interface
  PlayerModel _player = PlayerModel(
    level: 1, 
    xp: 0.0, 
    fisico: 0, 
    mental: 0, 
    missoes: []
  );

  PlayerModel get player => _player;

  PlayerController() {
    _init();
  }

  // Carrega os dados do JSON ao iniciar o App
  Future<void> _init() async {
    _player = await _service.loadPlayer();
    
    // Se for a primeira vez (lista vazia), criamos as missões padrão
    if (_player.missoes.isEmpty) {
      _player.missoes = [
        MissionModel(id: '1', titulo: 'Treino Intenso', recompensaXP: 20, tipo: 'fisico'),
        MissionModel(id: '2', titulo: 'Leitura Focada', recompensaXP: 15, tipo: 'mental'),
        MissionModel(id: '3', titulo: 'Meditação', recompensaXP: 10, tipo: 'mental'),
      ];
      await _service.savePlayer(_player);
    }
    notifyListeners();
  }

  // CORREÇÃO: Agora aceita o objeto MissionModel completo, resolvendo o erro da imagem a88e53
  void concluirMissao(MissionModel missao) {
    if (missao.foiConcluidaHoje) return;

    // Processa o ganho de XP
    _player.xp += (missao.recompensaXP / 100);

    // Incrementa atributos baseados no tipo da missão
    if (missao.tipo == 'fisico') _player.fisico += 1;
    if (missao.tipo == 'mental') _player.mental += 1;

    // Lógica de Level Up
    if (_player.xp >= 1.0) {
      _player.level += 1;
      _player.xp = 0.0;
    }

    // Registra a conclusão e salva no arquivo JSON
    missao.ultimaConclusao = DateTime.now();
    _service.savePlayer(_player);
    
    notifyListeners();
  }
}