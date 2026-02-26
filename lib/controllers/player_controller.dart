import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/mission_model.dart';
import '../services/player_service.dart';

class PlayerController extends ChangeNotifier {
  final PlayerService _service = PlayerService();
  
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

  Future<void> _init() async {
    _player = await _service.loadPlayer();
    
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

  // --- LOGICA DE ADIÇÃO DINÂMICA ---
  // O ID é gerado automaticamente aqui dentro para evitar erros do usuário
  void adicionarMissao({required String titulo, required double xp, required String tipo}) {
    final novaMissao = MissionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      titulo: titulo,
      recompensaXP: xp,
      tipo: tipo,
    );

    _player.missoes.add(novaMissao);
    _service.savePlayer(_player); // Salva no arquivo JSON imediatamente
    notifyListeners(); // Atualiza a lista na tela
  }

  void concluirMissao(MissionModel missao) {
    if (missao.foiConcluidaHoje) return;

    _player.xp += (missao.recompensaXP / 100);

    if (missao.tipo == 'fisico') _player.fisico += 1;
    if (missao.tipo == 'mental') _player.mental += 1;

    if (_player.xp >= 1.0) {
      _player.level += 1;
      _player.xp = 0.0;
    }

    missao.ultimaConclusao = DateTime.now();
    _service.savePlayer(_player);
    notifyListeners();
  }
}